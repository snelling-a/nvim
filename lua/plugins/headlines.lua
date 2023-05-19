local icons = require("config.ui.icons")
local M = { "lukas-reineke/headlines.nvim" }

M.dependencies = { "nvim-treesitter/nvim-treesitter" }

M.opts = {
	markdown = {
		codeblock_highlight = "CodeBlock",
		dash_highlight = "Dash",
		dash_string = icons.misc.square,
		fat_headlines = true,
		fat_headline_lower_string = "",
		quote_highlight = "Quote",
		quote_string = icons.fillchars.vert,
	},
}

return M
