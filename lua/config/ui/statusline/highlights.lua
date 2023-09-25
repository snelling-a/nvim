local Lsp = require("config.ui.statusline.lsp")
local Statusline = require("config.ui.statusline")

local M = {}

function M.defintions()
	Lsp.lsp_hldefs()

	local green_fg = Statusline.get_hl("ModeMsg")
	Statusline.set_hl("StatusGreen", {
		fg = green_fg,
		bg = Statusline.bg,
	})

	local red_fg = Statusline.get_hl("ErrorMsg")
	Statusline.set_hl("StatusRed", {
		fg = red_fg,
		bg = Statusline.bg,
	})

	local blue_fg = Statusline.get_hl("Title")
	Statusline.set_hl("StatusBlue", {
		fg = blue_fg,
		bg = Statusline.bg,
	})

	local cyan_fg = Statusline.get_hl("FoldColumn")
	Statusline.set_hl("StatusCyan", {
		fg = cyan_fg,
		bg = Statusline.bg,
	})

	local magenta_fg = Statusline.get_hl("Conditional")
	Statusline.set_hl("StatusMagenta", {
		fg = magenta_fg,
		bg = Statusline.bg,
	})
end

return M
