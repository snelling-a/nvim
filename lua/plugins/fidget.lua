local Icons = require("ui.icons")

---@type LazySpec
local M = { "j-hui/fidget.nvim" }

-- M.enabled = false
M.event = { "VeryLazy" }

M.opts = {
	progress = {
		display = {
			render_limit = 10,
			done_icon = Icons.progress.done,
			progress_icon = { pattern = "bouncing_bar", period = 1 },
		},
	},
	notification = {
		poll_rate = 10,
		filter = vim.log.levels.INFO,
		override_vim_notify = true,
		configs = {
			default = {
				name = nil,
				icon = nil,
				debug_annote = Icons.dap.Breakpoint,
				info_annote = Icons.diagnostics.Info,
				warn_annote = Icons.diagnostics.Warn,
				error_annote = Icons.diagnostics.Error,
			},
		},
		view = {
			stack_upwards = false,
			-- stack_upwards = true,
			group_separator = nil,
		},
		window = { winblend = 0 },
	},
}

return M
