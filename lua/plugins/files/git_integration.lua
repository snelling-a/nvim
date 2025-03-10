local ns_id = vim.api.nvim_create_namespace("mini_files_git")
local _, MiniFiles = pcall(require, "mini.files")

---@alias cache table<string, {time: number, statusMap: table<string, string>}>

---@type cache
local gitStatusCache = {}
local cacheTimeout = 2000

---@param status string
---@return string symbol, string hlGroup
local function mapSymbols(status)
	local statusMap = {
		[" M"] = { symbol = "•", hlGroup = "GitSignsChange" }, -- Modified in the working directory
		["M "] = { symbol = "✹", hlGroup = "GitSignsChange" }, -- modified in index
		["MM"] = { symbol = "≠", hlGroup = "GitSignsChange" }, -- modified in both working tree and index
		["A "] = { symbol = "+", hlGroup = "GitSignsAdd" }, -- Added to the staging area, new file
		["AA"] = { symbol = "≈", hlGroup = "GitSignsAdd" }, -- file is added in both working tree and index
		["D "] = { symbol = "-", hlGroup = "GitSignsDelete" }, -- Deleted from the staging area
		["AM"] = { symbol = "⊕", hlGroup = "GitSignsChange" }, -- added in working tree, modified in index
		["AD"] = { symbol = "-•", hlGroup = "GitSignsChange" }, -- Added in the index and deleted in the working directory
		["R "] = { symbol = "→", hlGroup = "GitSignsChange" }, -- Renamed in the index
		["U "] = { symbol = "‖", hlGroup = "GitSignsChange" }, -- Unmerged path
		["UU"] = { symbol = "⇄", hlGroup = "GitSignsAdd" }, -- file is unmerged
		["UA"] = { symbol = "⊕", hlGroup = "GitSignsAdd" }, -- file is unmerged and added in working tree
		["??"] = { symbol = "?", hlGroup = "GitSignsDelete" }, -- Untracked files
		["!!"] = { symbol = "!", hlGroup = "GitSignsChange" }, -- Ignored files
	}

	local result = statusMap[status] or { symbol = "?", hlGroup = "NonText" }
	return result.symbol, result.hlGroup
end

---@param cwd string
---@param callback function
---@return nil
local function fetchGitStatus(cwd, callback)
	local function on_exit(content)
		if content.code == 0 then
			callback(content.stdout)
			vim.g.content = content.stdout
		end
	end
	vim.system({ "git", "status", "--ignored", "--porcelain" }, { text = true, cwd = cwd }, on_exit)
end

---@param str? string
---@return string
local function escapePattern(str)
	return str and str:gsub("([%^%$%(%)%%%.%[%]%*%+%-%?])", "%%%1") or ""
end

---@param buf_id integer
---@param gitStatusMap table<string, string>
---@return nil
local function updateMiniWithGit(buf_id, gitStatusMap)
	vim.schedule(function()
		local ok, nlines = pcall(vim.api.nvim_buf_line_count, buf_id)
		if not ok then
			return
		end
		---@type boolean, string|nil
		local okay, cwd = pcall(vim.fs.root, buf_id, ".git")
		if not okay then
			return
		end
		local escapedcwd = escapePattern(cwd)

		for i = 1, nlines do
			---@type {path: string}|nil
			local entry = MiniFiles.get_fs_entry(buf_id, i)
			if not entry then
				break
			end
			local relativePath = entry.path:gsub("^" .. escapedcwd .. "/", "")
			local status = gitStatusMap[relativePath]

			if status then
				local symbol, hlGroup = mapSymbols(status)
				vim.api.nvim_buf_set_extmark(buf_id, ns_id, i - 1, 0, {
					sign_text = symbol,
					sign_hl_group = hlGroup,
					priority = 2,
				})
			end
		end
	end)
end

---@param content string
---@return table
local function parseGitStatus(content)
	---@type table<string, string>
	local gitStatusMap = {}
	for line in content:gmatch("[^\r\n]+") do
		---@type string,string
		local status, filePath = string.match(line, "^(..)%s+(.*)")
		---@type string[]
		local parts = {}
		for part in filePath:gmatch("[^/]+") do
			table.insert(parts, part)
		end

		local currentKey = ""
		for i, part in ipairs(parts) do
			if i > 1 then
				currentKey = currentKey .. "/" .. part
			else
				currentKey = part
			end

			if i == #parts then
				gitStatusMap[currentKey] = status
			else
				if not gitStatusMap[currentKey] then
					gitStatusMap[currentKey] = status
				end
			end
		end
	end
	return gitStatusMap
end

---@param buf_id integer
---@return nil
local function updateGitStatus(buf_id)
	if not vim.fs.root(vim.uv.cwd() or vim.env.PWD, ".git") then
		return
	end

	local cwd = vim.fn.expand("%:p:h")
	local currentTime = os.time()
	if gitStatusCache[cwd] and currentTime - gitStatusCache[cwd].time < cacheTimeout then
		updateMiniWithGit(buf_id, gitStatusCache[cwd].statusMap)
	else
		fetchGitStatus(cwd, function(content)
			local gitStatusMap = parseGitStatus(content)
			gitStatusCache[cwd] = {
				time = currentTime,
				statusMap = gitStatusMap,
			}
			updateMiniWithGit(buf_id, gitStatusMap)
		end)
	end
end

---@return nil
local function clearCache()
	gitStatusCache = {}
end

local group = require("user.autocmd").augroup("mini.files.git")

vim.api.nvim_create_autocmd("User", {
	callback = function(event)
		updateGitStatus(event.buf)
	end,
	group = group,
	pattern = "MiniFilesExplorerOpen",
})

vim.api.nvim_create_autocmd("User", {
	callback = function()
		clearCache()
	end,
	group = group,
	pattern = "MiniFilesExplorerClose",
})

vim.api.nvim_create_autocmd("User", {
	callback = function(event)
		local bufnr = event.data.buf_id
		local cwd = vim.fn.expand("%:p:h")
		if gitStatusCache[cwd] then
			updateMiniWithGit(bufnr, gitStatusCache[cwd].statusMap)
		end
	end,
	group = group,
	pattern = "MiniFilesBufferUpdate",
})
