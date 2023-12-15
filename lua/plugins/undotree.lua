---@type LazySpec
local M = { "mbbill/undotree" }

M.keys = {
	{ "<leader>u", vim.cmd.UndotreeToggle, desc = "Toggle [u]ndotree" },
}

return M
