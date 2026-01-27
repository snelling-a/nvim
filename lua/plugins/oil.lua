vim.pack.add({
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/refractalize/oil-git-status.nvim" },
})

require("oil").setup({
	view_options = { show_hidden = true },
	win_options = { signcolumn = "yes:2" },
})
require("oil-git-status").setup()

vim.keymap.set("n", "<M-o>", "<cmd>Oil<cr>", { desc = "Open parent directory" })
