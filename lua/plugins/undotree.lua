--- @type LazySpec
local M = {
	"mbbill/undotree",
}

M.cmd = "UndotreeToggle"

M.keys = {
	{
		"<leader>u",
		vim.cmd.UndotreeToggle,
		desc = "Toggle [u]ndotree",
	},
}

return M
