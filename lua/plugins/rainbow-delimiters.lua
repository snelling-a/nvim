return {
	"HiPhish/rainbow-delimiters.nvim",
	dependencies = "nvim-treesitter/nvim-treesitter",
	event = "BufEnter",
	config = function()
		local delim = require("rainbow-delimiters")
		vim.g.rainbow_delimiters = {
			strategy = {
				[""] = delim.strategy["global"],
				vim = delim.strategy["local"],
			},
			query = {
				[""] = "rainbow-delimiters",
				-- lua = 'rainbow-blocks',
			},
			-- highlight = {
			-- 	"TSRainbowRed",
			-- 	"TSRainbowYellow",
			-- 	"TSRainbowBlue",
			-- 	"TSRainbowOrange",
			-- 	"TSRainbowGreen",
			-- 	"TSRainbowViolet",
			-- 	"TSRainbowCyan",
			-- },
		}
	end,
}
