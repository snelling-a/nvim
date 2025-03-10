---@type LazySpec
return {
	"j-hui/fidget.nvim",
	config = function()
		local Icons = require("icons")
		local fidget = require("fidget")

		fidget.setup({
			notification = {
				configs = {
					default = {
						debug_annote = "DEBUG",
						error_annote = Icons.diagnostics.Error,
						icon = nil,
						info_annote = Icons.diagnostics.Info,
						name = nil,
						warn_annote = Icons.diagnostics.Warn,
					},
				},
				override_vim_notify = true,
				view = { stack_upwards = false },
				window = { winblend = 0 },
			},
		})

		vim.api.nvim_create_user_command("Replay", fidget.notification.show_history, {
			desc = "Get notifications",
		})
	end,
}
