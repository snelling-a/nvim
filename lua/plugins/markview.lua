---@class LazySpec
return {
	"OXY2DEV/markview.nvim",
	lazy = false,
	enabled = vim.fn.getcwd() ~= vim.fn.expand("~") .. "/notes",
	ft = { "markdown" },
	config = function()
		require("markview").setup()
		require("markview.extras.headings").setup()
		require("markview.extras.editor").setup()

		local presets = require("markview.presets")
		require("markview").setup({
			markdown = {
				-- headings = presets.headings.simple,
				tables = presets.tables.rounded,
			},
		})
	end,
}
