---@type LazySpec
return {
	"folke/lazydev.nvim",
	dependencies = {
		{ "Bilal2453/luvit-meta", lazy = true },
	},
	ft = { "lua" },
	event = { "LspAttach" },
	config = function()
		require("lazydev").setup({
			library = {
				{ path = "lazy.nvim" },
				{
					path = "luvit-meta/library",
					words = { "vim%.uv", "vim%.loop" },
				},
			},
			integrations = { cmp = false },
		})
	end,
}
