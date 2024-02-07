local desc = "Toggle [u]ndotree"

---@type LazySpec
local M = { "mbbill/undotree" }

M.keys = {
	{ "<leader>u", desc = desc },
}

function M.config()
	require("keymap").leader("u", vim.cmd.UndotreeToggle, { desc = desc })

	vim.g.undotree_SetFocusWhenToggle = 1
	vim.g.undotree_ShortIndicators = 1
	vim.g.undotree_HelpLine = 0
end

return M
