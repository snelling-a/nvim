local M = { "rcarriga/nvim-dap-ui" }

function M.keys()
	local widgets = require("dap.ui.widgets")

	return {
		{
			"<Leader>dp",
			widgets.preview,
			desc = "DAP preview",
		},
		{
			"<Leader>df",
			function() widgets.centered_float(widgets.frames) end,
			desc = "DAP frames",
		},
		{
			"<Leader>dh",
			widgets.hover,
			desc = "DAP hover",
		},
		{
			"<Leader>ds",
			function() widgets.centered_float(widgets.scopes) end,
			desc = "DAP scopes",
		},
	}
end

M.opts = {
	icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
	controls = {
		icons = {
			pause = "⏸",
			play = "▶",
			step_into = "⏎",
			step_over = "⏭",
			step_out = "⏮",
			step_back = "b",
			run_last = "▶▶",
			terminate = "⏹",
		},
	},
}

return M
