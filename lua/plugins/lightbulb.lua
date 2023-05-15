local icon = require("config.ui.icons").misc.lightbulb_alert

local M = { "kosayoda/nvim-lightbulb" }

M.dependencies = { "antoinemadec/FixCursorHold.nvim" }

M.opts = {
	status_text = {
		enabled = true,
		text = icon,
	},
	autocmd = {
		enabled = true,
		pattern = { "*" },
		events = { "CursorHold", "CursorHoldI" },
	},
}

return M
