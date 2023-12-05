local M = {}

function M.defintions()
	local Lsp = require("ui.status.line.lsp")
	local Util = require("ui.status.line.util")
	local Ui = require("ui")

	Lsp.lsp_hldefs()

	local bg = Util.bg

	local green_fg = Ui.get_hl("ModeMsg")
	Util.set_hl("StatusGreen", {
		fg = green_fg,
		bg = bg,
	})

	local red_fg = Ui.get_hl("ErrorMsg")
	Util.set_hl("StatusRed", {
		fg = red_fg,
		bg = bg,
	})

	local blue_fg = Ui.get_hl("Title")
	Util.set_hl("StatusBlue", {
		fg = blue_fg,
		bg = bg,
	})

	local cyan_fg = Ui.get_hl("FoldColumn")
	Util.set_hl("StatusCyan", {
		fg = cyan_fg,
		bg = bg,
	})

	local magenta_fg = Ui.get_hl("Conditional")
	Util.set_hl("StatusMagenta", {
		fg = magenta_fg,
		bg = bg,
	})
end

return M
