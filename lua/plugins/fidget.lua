---@type LazySpec
return {
	"j-hui/fidget.nvim",
	config = function()
		require("fidget").setup({
			notification = {
				configs = {
					default = {
						debug_annote = "DEBUG",
						error_annote = Config.icons.diagnostics.Error,
						icon = nil,
						info_annote = Config.icons.diagnostics.Info,
						name = nil,
						warn_annote = Config.icons.diagnostics.Warn,
					},
				},
				override_vim_notify = true,
				view = { stack_upwards = false },
				window = { winblend = 0 },
			},
		})
	end,
}
