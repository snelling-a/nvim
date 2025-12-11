vim.pack.add({
	"https://github.com/nvim-mini/mini.icons",
	"https://github.com/nvim-mini/mini.pairs",
	"https://github.com/nvim-mini/mini.surround",
})
require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()
MiniIcons.tweak_lsp_kind()
require("mini.pairs").setup()
require("mini.surround").setup({
	mappings = {
		add = "ys",
		delete = "ds",
		find = "",
		find_left = "",
		highlight = "",
		replace = "cs",
		suffix_last = "",
		suffix_next = "",
	},
	search_method = "cover_or_next",
})
-- Use S in visual mode to avoid timeout conflict with y
vim.keymap.set("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { desc = "Add surrounding", silent = true })
vim.keymap.del("x", "ys")
