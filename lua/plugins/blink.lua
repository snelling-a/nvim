vim.pack.add({
	{ src = "https://github.com/Saghen/blink.cmp", version = vim.version.range("1.*") },
	{ src = "https://github.com/rafamadriz/friendly-snippets" },
})

require("blink.cmp").setup({
	completion = {
		documentation = { auto_show = true },
		menu = {
			auto_show = function()
				local ns = vim.api.nvim_create_namespace("nvim.lsp.inline_completion")
				local marks = vim.api.nvim_buf_get_extmarks(0, ns, 0, -1, {})
				return #marks == 0
			end,
		},
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
