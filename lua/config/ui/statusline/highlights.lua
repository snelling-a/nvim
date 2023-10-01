local Lsp = require("config.ui.statusline.lsp")
local Util = require("config.ui.statusline.util")

local M = {}

function M.defintions()
	Lsp.lsp_hldefs()

	local green_fg = Util.get_hl("ModeMsg")
	Util.set_hl("StatusGreen", {
		fg = green_fg,
		bg = Util.bg,
	})

	local red_fg = Util.get_hl("ErrorMsg")
	Util.set_hl("StatusRed", {
		fg = red_fg,
		bg = Util.bg,
	})

	local blue_fg = Util.get_hl("Title")
	Util.set_hl("StatusBlue", {
		fg = blue_fg,
		bg = Util.bg,
	})

	local cyan_fg = Util.get_hl("FoldColumn")
	Util.set_hl("StatusCyan", {
		fg = cyan_fg,
		bg = Util.bg,
	})

	local magenta_fg = Util.get_hl("Conditional")
	Util.set_hl("StatusMagenta", {
		fg = magenta_fg,
		bg = Util.bg,
	})
end

return M
