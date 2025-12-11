local Module = {}

local ns_id = vim.api.nvim_create_namespace("NetrwGit")

-- Define signs (similar to gitsigns)
local signs = {
	added = { text = "┃", hl = "GitSignsAdd" },
	modified = { text = "┃", hl = "GitSignsChange" },
	untracked = { text = "┃", hl = "GitSignsUntracked" },
}

-- Priority: higher = takes precedence when aggregating folder status
local status_priority = {
	ignored = 0,
	untracked = 1,
	added = 2,
	modified = 3,
	deleted = 4,
}

-- Cache: repo_root -> { lines = {...}, status_by_depth = { [depth] = { name -> status } } }
local repo_cache = {}

---Parse a single git status line and return status
---@param xy string the two-character status code
---@return string? status
local function parse_status_code(xy)
	local x, y = xy:sub(1, 1), xy:sub(2, 2)

	if xy == "!!" then
		return "ignored"
	elseif xy == "??" then
		return "untracked"
	elseif x == "D" or y == "D" then
		return "deleted"
	elseif x == "A" and y == " " then
		return "added"
	elseif x == "M" or y == "M" or x == "A" then
		return "modified"
	end
	return nil
end

---Build status maps for all directory depths from git status output
---@param lines string[] git status output lines
---@return table<number, table<string, string>> status_by_depth: depth -> { name -> status }
local function build_status_maps(lines)
	-- status_by_depth[1] = root level items
	-- status_by_depth[2] = items inside first-level folders
	-- etc.
	local status_by_depth = {}

	for _, line in ipairs(lines) do
		if #line >= 4 then
			local xy = line:sub(1, 2)
			local filepath = line:sub(4)

			-- Handle renamed files (old -> new)
			if filepath:match(" %-> ") then
				filepath = filepath:match(" %-> (.+)$")
			end

			local status = parse_status_code(xy)
			if status then
				-- Split path into components and mark each level
				local components = {}
				for part in filepath:gmatch("([^/]+)/?") do
					table.insert(components, part)
				end

				-- Mark each directory component at its depth
				for depth, name in ipairs(components) do
					if not status_by_depth[depth] then
						status_by_depth[depth] = {}
					end

					local existing = status_by_depth[depth][name]
					if not existing or status_priority[status] > status_priority[existing] then
						status_by_depth[depth][name] = status
					end
				end
			end
		end
	end

	return status_by_depth
end

---Extract filename and depth from a netrw buffer line
---@param line string the line content
---@return string? filename, number depth (1-indexed, 0 for skipped lines)
local function extract_filename(line)
	-- Skip empty lines
	if line == "" or line:match("^%s*$") then
		return nil, 0
	end

	-- Skip header lines (lines starting with quotes)
	if line:match('^"') then
		return nil, 0
	end

	-- Skip .. and current directory marker
	if line == "../" or line:match("^[^|]+/$") then
		return nil, 0
	end

	-- Count pipe characters to determine depth
	local depth = 0
	for _ in line:gmatch("|") do
		depth = depth + 1
	end

	-- Strip tree-style prefix (e.g., "| " or "| | ")
	local stripped = line:gsub("^[|%s]+", "")

	-- Get the filename (first non-space sequence)
	local name = stripped:match("^(%S+)")
	if not name then
		return nil, 0
	end

	-- Skip . and .. entries
	if name == "./" or name == "../" then
		return nil, 0
	end

	return name, depth
end

---Apply signs to buffer
---@param bufnr number buffer number
---@param status_by_depth table<number, table<string, string>> depth -> { name -> status }
local function apply_signs(bufnr, status_by_depth)
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)

	if vim.tbl_isempty(status_by_depth) then
		return
	end

	-- Enable sign column
	local win = vim.fn.bufwinid(bufnr)
	if win ~= -1 then
		vim.wo[win].signcolumn = "yes"
	end

	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

	for lnum, line in ipairs(lines) do
		local name, depth = extract_filename(line)
		if name and depth > 0 then
			-- Remove trailing slash for directory lookup
			local lookup_name = name:gsub("/$", "")

			-- Look up status at this depth
			local depth_status = status_by_depth[depth]
			local status = depth_status and depth_status[lookup_name]

			if status and signs[status] then
				local sign = signs[status]
				vim.api.nvim_buf_set_extmark(bufnr, ns_id, lnum - 1, 0, {
					sign_text = sign.text,
					sign_hl_group = sign.hl,
				})
			end
		end
	end
end

---Fetch git status asynchronously and apply signs
---@param dir string directory path
---@param bufnr number buffer number
---@param callback? function optional callback when done
local function fetch_git_status_async(dir, bufnr, callback)
	-- First get repo root (quick operation)
	local repo_root_out = vim.fn.systemlist({ "git", "-C", dir, "rev-parse", "--show-toplevel" })
	if vim.v.shell_error ~= 0 or #repo_root_out == 0 then
		if callback then
			callback({})
		end
		return
	end
	local repo_root = repo_root_out[1]

	-- Check if we have cached status for this repo
	if repo_cache[repo_root] and repo_cache[repo_root].status_by_depth then
		apply_signs(bufnr, repo_cache[repo_root].status_by_depth)
		if callback then
			callback(repo_cache[repo_root].status_by_depth)
		end
		return
	end

	-- Run git status async
	vim.system(
		{ "git", "-C", repo_root, "status", "--porcelain", "-uall" },
		{ text = true },
		vim.schedule_wrap(function(result)
			if result.code ~= 0 then
				if callback then
					callback({})
				end
				return
			end

			local lines = vim.split(result.stdout or "", "\n", { trimempty = true })

			-- Build status maps for all depths
			local status_by_depth = build_status_maps(lines)

			-- Cache for this repo
			repo_cache[repo_root] = {
				lines = lines,
				status_by_depth = status_by_depth,
			}

			apply_signs(bufnr, status_by_depth)

			if callback then
				callback(status_by_depth)
			end
		end)
	)
end

---Clear the status cache
---@param repo_root? string repo to clear (or all if nil)
function Module.clear_cache(repo_root)
	if repo_root then
		repo_cache[repo_root] = nil
	else
		repo_cache = {}
	end
end

---Add git status signs to netrw buffer (async)
---@param buf? number buffer number
function Module.add_signs(buf)
	local bufnr = buf or vim.api.nvim_get_current_buf()

	if vim.fn.exists("b:netrw_curdir") ~= 1 then
		return
	end

	local current_dir = vim.b[bufnr].netrw_curdir
	if not current_dir then
		return
	end

	fetch_git_status_async(current_dir, bufnr)
end

---Debug function to see what's happening
function Module.debug()
	local bufnr = vim.api.nvim_get_current_buf()
	local dir = vim.b[bufnr].netrw_curdir

	print("Buffer:", bufnr)
	print("Filetype:", vim.bo[bufnr].filetype)
	print("Directory:", vim.inspect(dir))

	if not dir then
		print("ERROR: b:netrw_curdir is nil!")
		return
	end

	local repo_root = vim.fn.systemlist({ "git", "-C", dir, "rev-parse", "--show-toplevel" })[1]
	print("Repo root:", repo_root)

	local lines = vim.fn.systemlist({ "git", "-C", repo_root, "status", "--porcelain", "-uall" })
	print("Git status lines:", #lines)
	for i, line in ipairs(lines) do
		if i <= 5 then
			print("  ", vim.inspect(line))
		end
	end

	local status_by_depth = build_status_maps(lines)
	print("Status by depth:")
	for depth, status in pairs(status_by_depth) do
		print("  Depth", depth, ":")
		for name, st in pairs(status) do
			print("    ", name, "=", st)
		end
	end

	print("Buffer lines and extracted names:")
	local buf_lines = vim.api.nvim_buf_get_lines(bufnr, 0, 15, false)
	for i, line in ipairs(buf_lines) do
		local name, depth = extract_filename(line)
		local lookup = name and name:gsub("/$", "") or nil
		local depth_status = status_by_depth[depth]
		local match = lookup and depth_status and depth_status[lookup] or nil
		print("  ", i, vim.inspect(line), "-> name:", vim.inspect(name), "depth:", depth, "match:", vim.inspect(match))
	end
end

return Module
