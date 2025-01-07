---@param modifier? string see |filename-modifiers|
---@return string FileName relative to home directory by default
local function get_file_name(modifier)
	modifier = modifier or ":."

	return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), modifier)
end

---@class user.Util
local M = {}

-- capitalize the first letter of a string
---@param str string Input string
---@return string # Input string with the first letter capitalized
function M.capitalize_first_letter(str)
	return str:sub(1, 1):upper() .. str:gsub("^%u(.*)", function(rest)
		return rest:lower()
	end)
end

---@param bufnr integer
function M.easy_quit(bufnr)
	vim.bo[bufnr].buflisted = false
	vim.keymap.set("n", "q", function()
		if M.is_man(bufnr) then
			vim.cmd.quitall()
		end

		xpcall(vim.cmd.close, function()
			vim.cmd.bwipeout()
		end)

		vim.cmd.wincmd("p")
	end, { buffer = bufnr, desc = "Quit Buffer" })
end

--- Get the icon and color for a file
---@param fname string?
---@return string icon
---@return string color hightlight-group
function M.get_file_icon(fname)
	fname = fname or get_file_name()

	return require("nvim-web-devicons").get_icon_color(fname, vim.fn.fnamemodify(fname, ":e"), { default = true })
end

-- Get the path to the Node.js executable.
function M.get_node_path()
	local result = vim.fn.system("which node")

	result = result:gsub("\r\n$", ""):gsub("\n$", "")

	if vim.v.shell_error ~= 0 then
		vim.notify("Error: Could not find Node.js path.")
		return nil
	end

	return result
end

---@param client_name string vim.lsp.Client.name
---@return string
function M.get_lsp_icon(client_name)
	local icon = Config.icons.servers[client_name:lower()]
	if icon then
		return icon
	end

	return Config.icons.kind_icons.Lsp
end

---@param bufnr integer
---@return boolean
function M.is_man(bufnr)
	return vim.bo[bufnr].filetype == "man"
end

---@param ft? string file type
---@return boolean Disabled is file type disabled
function M.is_filetype_disabled(ft)
	ft = ft or vim.bo.filetype
	return vim.tbl_contains(DisabledFiletypes, ft)
end

-- Remove the listchars for multispace
-- use for languages that utilize multispace for formatting
-- i.e. toml, prisma
function M.remove_multispace_listchar()
	---@type table<string, string>
	local listchars = {}

	for k, v in pairs(Config.icons.listchars) do
		if k ~= "multispace" then
			listchars[k] = v
		end
	end

	vim.opt_local.listchars = listchars
end

return M
