local M = {}

function M.defintions()
	local Lsp = require("ui.status.line.lsp")
	local Util = require("ui.status.line.util")
	local Ui = require("ui")

	Lsp.lsp_hldefs()

	local green_fg = Ui.get_hl("ModeMsg")
	Util.set_hl("StatusGreen", { bg = Util.bg, fg = green_fg })

	local red_fg = Ui.get_hl("ErrorMsg")
	Util.set_hl("StatusRed", { bg = Util.bg, fg = red_fg })

	local blue_fg = Ui.get_hl("Title")
	Util.set_hl("StatusBlue", { bg = Util.bg, fg = blue_fg })

	local cyan_fg = Ui.get_hl("FoldColumn")
	Util.set_hl("StatusCyan", { bg = Util.bg, fg = cyan_fg })

	local magenta_fg = Ui.get_hl("Conditional")
	Util.set_hl("StatusMagenta", { bg = Util.bg, fg = magenta_fg })
end

return M
