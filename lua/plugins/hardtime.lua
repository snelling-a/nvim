---@type LazySpec
return {
	"m4xshen/hardtime.nvim",
	dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
	event = { "LazyFile" },
	config = function()
		require("hardtime").setup({
			disabled_filetypes = DisabledFiletypes,
			disabled_keys = {
				["<Up>"] = { "n", "x" },
				["<Down>"] = { "n", "x" },
				["<Left>"] = { "n", "x" },
				["<Right>"] = { "n", "x" },
			},
			max_count = 10,
		})
	end,
}
