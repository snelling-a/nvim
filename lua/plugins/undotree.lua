---@type LazySpec
local M = {
	"mbbill/undotree",
}

M.cmd = {
	"UndotreeToggle",
}

M.keys = {
	---@diagnostic disable-next-line: missing-fields
	{
		"<leader>u",
		vim.cmd.UndotreeToggle,
		desc = "Toggle [u]ndotree",
	},
}

return M
