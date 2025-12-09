local Module = {}

-- Store the namespace ID globally for the module
local ns_id = vim.api.nvim_create_namespace("NetrwIcons")
---@type table<string, string>
local sid_cache = {}

---Get the sid of script searching by patter
---@param pattern string pattern to search for
---@return string? sid of script that matches pattern
local function get_sid(pattern)
	if sid_cache[pattern] then
		return sid_cache[pattern]
	end

	local lines = vim.split(vim.api.nvim_exec2("scriptnames", { output = true }).output or "", "\n", { plain = true })

	local sid --[[@type string]]
	for _, line in ipairs(lines) do
		local _, matches = line:gsub(pattern, "")
		if matches > 0 then
			sid = vim.trim(vim.split(line, ":", { plain = true, trimempty = true })[1])
			goto continue
		end
	end

	::continue::

	if not sid and sid == "" then
		return nil
	end

	sid_cache[pattern] = sid
	return sid
end

local get_node_fn = ""

local function netrw_gx()
	if get_node_fn ~= "" then
		return vim.trim(vim.fn.execute(get_node_fn))
	end

	local netrw_sid = get_sid("autoload.netrw.vim")

	if not netrw_sid then
		return
	end

	get_node_fn = ([[ echo function("<SNR>%s_NetrwGetWord")() ]]):format(netrw_sid)
	-- local node = vim.api.nvim_exec2(cmd_fmt:format(netrw_sid), { output = true }).output

	return vim.trim(vim.fn.execute(get_node_fn))
end

-- Helper function to get the current buffer's syntax group name
local function current_syntax_name()
	return vim.fn.synIDattr(vim.fn.synID(vim.fn.line("."), vim.fn.col("."), 0), "name")
end

-- Main function to add the icons
function Module.add_icons(buf)
	local bufnr = buf or vim.api.nvim_get_current_buf()

	-- Check if netrw is loaded and current dir is available
	if vim.fn.exists("b:netrw_curdir") ~= 1 then
		return
	end

	-- Clear any previous marks in this namespace (equivalent to prop_remove)
	-- Clears marks from line 0 to line -1 (end of file)
	vim.api.nvim_buf_clear_namespace(bufnr, ns_id, 0, -1)

	-- Store cursor position
	local saved_view = vim.fn.winsaveview()

	local current_dir = vim.fn.get(vim.b, "netrw_curdir")

	-- Start from the beginning of the file
	vim.cmd.normal("gg0")

	local pattern = "\\f\\+"

	-- Check for liststyle 1 (long listing)
	if vim.fn.get(vim.b, "netrw_liststyle") == 1 then
		-- The timestamps shown at the side should not be iterated
		local files = vim.fn.readdir(current_dir)
		local max_length = 0
		for _, f in ipairs(files) do
			max_length = math.max(max_length, #f)
		end

		local max_col = max_length + 2
		pattern = string.format("\\f\\+\\%%<%dc", max_col)
	end

	-- Skip areas that aren't file/dir names
	local skip =
		'synIDattr(synID(line("."), col("."), 0), "name") !~ "netrwDir\\\\|netrwExe\\\\|netrwSymLink\\\\|netrwPlain"'

	-- Loop through all found file/directory names
	while vim.fn.search(pattern, "W", 0, 0, skip) > 0 do
		local pos = vim.fn.getpos(".")
		local node = netrw_gx() or ""
		vim.fn.setpos(".", pos)

		local is_dir = node:match("/$") ~= nil
		local is_symlink = current_syntax_name() == "netrwSymLink"

		local symbol = "" --[[@type string]]
		local hl = "" --[[@type string]]

		-- Determine the icon symbol
		if is_symlink then
			symbol = "" -- Fallback for symlink
			-- symbol = '🔗'
			hl = "netrwSymLink"
		elseif is_dir then
			local ok_devicons, devicons = pcall(require, "nvim-web-devicons")
			if ok_devicons then
				symbol, hl = devicons.get_icon(vim.fn.trim(node, "/"))
			end

			if not symbol or not hl then
				symbol = "" -- Fallback for directory
				-- symbol = '📁'
				hl = "netrwDir"
			end
		else
			local ok_devicons, devicons = pcall(require, "nvim-web-devicons")
			if ok_devicons then
				symbol, hl = devicons.get_icon(node)
			end

			if not symbol or not hl then
				-- Fallback for unknown file
				symbol = "󰈙"
				-- symbol = '📄'
				hl = "Normal"
			end
		end

		-- Add the icon using nvim_buf_set_extmark (equivalent to prop_add)
		if symbol and symbol ~= "" then
			-- Extmark line and column are 0-indexed
			local lnum = vim.fn.line(".") - 1
			local col = vim.fn.col(".") - 1
			local text = symbol .. " "

			vim.api.nvim_buf_set_extmark(bufnr, ns_id, lnum, col, {
				virt_text = { { text, hl } }, -- Apply a highlight group
				-- virt_text_pos = 'overlay',
				virt_text_pos = "inline",
			})
		end

		-- Move to the end of the node for the next search
		vim.fn.search("\\V" .. vim.fn.escape(node, "\\"), "We", vim.fn.line("."))

		-- Handle symlink display adjustments
		if is_symlink then
			-- if there's a -->, then the view is long and we can just go to the end
			if vim.fn.search("\\s\\+-->\\s*\\f\\+", "Wn", vim.fn.line(".")) then
				vim.cmd.normal("$")
			end
		end
	end

	-- Recover cursor position
	vim.fn.winrestview(saved_view)
end

return Module
