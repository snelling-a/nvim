local M = { "lukas-reineke/headlines.nvim" }

M.dependencies = { "nvim-treesitter/nvim-treesitter" }

M.opts = {
	markdown = {
		codeblock_highlight = "CodeBlock",
		dash_highlight = "Dash",
		dash_string = "x",
		fat_headlines = false,
		headline_highlights = { "Headline" },
		quote_highlight = "Quote",
		quote_string = "┃",
	},
}

return M
