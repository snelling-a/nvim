vim.pack.add({
	{ src = "https://github.com/Saghen/blink.cmp", version = vim.version.range("1.*") },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
})

require("blink.cmp").setup({
	completion = {
		documentation = { auto_show = true },
	},
	fuzzy = { implementation = "lua" },
	keymap = {
		preset = "super-tab",
		["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
		["<CR>"] = { "accept", "fallback" },
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
})
