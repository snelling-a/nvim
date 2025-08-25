---@param modifier? string see |filename-modifiers|
---@return string FileName relative to home directory by default
local function get_file_name(modifier)
	modifier = modifier or ":."

	return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), modifier)
end

local M = {}

--- Get the icon and color for a file
---@param fname string?
---@return string icon
---@return string color hightlight-group
function M.get_file_icon(fname)
	fname = fname or get_file_name()
	---@type boolean, {get_icon_color: fun(string, string, table): (string, string)}
	local okay, icons = pcall(require, "nvim-web-devicons")

	if not okay then
		return "", ""
	end

	return icons.get_icon_color(fname, vim.fn.fnamemodify(fname, ":e"), { default = true })
end

-- Remove the listchars for multispace
-- use for languages that utilize multispace for formatting
-- i.e. toml, prisma
function M.remove_multispace_listchar()
	---@type table<string, string>
	local listchars = {}

	for k, v in pairs(require("icons").listchars) do
		if k ~= "multispace" then
			listchars[k] = v
		end
	end

	vim.opt_local.listchars = listchars
end

return M
