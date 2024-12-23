if not vim.g.vscode then
	return {}
end

local enabled = {
	"lazy.nvim",
	"mini.ai",
	"mini.comment",
	"mini.extra",
	"mini.pairs",
	"mini.surround",
	"nvim-treesitter",
	"nvim-treesitter-textobjects",
	"nvim-ts-context-commentstring",
}

local Config = require("lazy.core.config")
Config.options.checker.enabled = false
Config.options.change_detection.enabled = false
Config.options.defaults.cond = function(plugin)
	return vim.tbl_contains(enabled, plugin.name)
end

vim.keymap.set("n", "<leader><space>", "<cmd>Find<cr>")
vim.keymap.set("n", "<leader>/", [[<cmd>lua require('vscode').action('workbench.action.findInFiles')<cr>]])
vim.keymap.set("n", "<leader>ss", [[<cmd>lua require('vscode').action('workbench.action.gotoSymbol')<cr>]])

vim.cmd.colorscheme("default")

---@type LazySpec
return {
	"nvim-treesitter/nvim-treesitter",
	opts = {
		highlight = { enable = false },
	},
}
