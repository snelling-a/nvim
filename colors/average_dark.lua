-- Made with 'mini.colors' module of https://github.com/echasnovski/mini.nvim

if vim.g.colors_name ~= nil then
	vim.cmd("highlight clear")
end
vim.g.colors_name = "average_dark"

-- Highlight groups
local hi = vim.api.nvim_set_hl

hi(0, "Character", { ctermfg = 108, fg = "#9bac8c" })
hi(0, "Comment", { ctermfg = 242, fg = "#6b6f79" })
hi(0, "Constant", { ctermfg = 250, fg = "#b9b9b9" })
hi(0, "CursorLine", { bg = "#282c3a", ctermbg = 236 })
hi(0, "CursorLineNr", { ctermfg = 251, fg = "#bfc1d2" })
hi(0, "DiagnosticError", { ctermfg = 168, fg = "#e16481" })
hi(0, "DiagnosticHint", { ctermfg = 249, fg = "#9bbbb7" })
hi(0, "DiagnosticInfo", { ctermfg = 110, fg = "#83b2c7" })
hi(0, "DiagnosticWarn", { ctermfg = 180, fg = "#d9ae7e" })
hi(0, "Directory", { ctermfg = 110, fg = "#8facc7" })
hi(0, "Error", { ctermfg = 168, fg = "#e06586" })
hi(0, "FoldColumn", { ctermfg = 244, fg = "#767c8a" })
hi(0, "Folded", { ctermfg = 244, fg = "#788192" })
hi(0, "Function", { ctermfg = 146, fg = "#9eb9d1" })
hi(0, "Identifier", { ctermfg = 145, fg = "#aeadb5" })
hi(0, "Ignore", { ctermfg = 234, fg = "#1b1f29" })
hi(0, "Keyword", { ctermfg = 247, fg = "#919ac1" })
hi(0, "LineNr", { ctermfg = 59, fg = "#585e71" })
hi(0, "MoreMsg", { ctermfg = 110, fg = "#83afdd" })
hi(0, "NonText", { ctermfg = 59, fg = "#5a5e68" })
hi(0, "Normal", { bg = "#1b1f29", ctermbg = 234, ctermfg = 188, fg = "#d7d8dc" })
hi(0, "Operator", { ctermfg = 248, fg = "#9fa9c5" })
hi(0, "Pmenu", { bg = "#242939", ctermbg = 235, ctermfg = 252, fg = "#caced9" })
hi(0, "PmenuSel", { bg = "#404a66", ctermbg = 239 })
hi(0, "PreProc", { ctermfg = 146, fg = "#be9cc6" })
hi(0, "Question", { ctermfg = 110, fg = "#98b5c8" })
hi(0, "Special", { ctermfg = 249, fg = "#abb4c8" })
hi(0, "SpecialKey", { ctermfg = 243, fg = "#6d717c" })
hi(0, "Statement", { ctermfg = 139, fg = "#a981b5" })
hi(0, "StatusBlue", { bg = "#383838", ctermbg = 237, ctermfg = 146, fg = "#9cb7cf" })
hi(0, "StatusCyan", { bg = "#383838", ctermbg = 237, ctermfg = 244, fg = "#767c8a" })
hi(0, "StatusDiagnosticError", { bg = "#383838", ctermbg = 237, ctermfg = 168, fg = "#e16481" })
hi(0, "StatusDiagnosticHint", { bg = "#383838", ctermbg = 237, ctermfg = 249, fg = "#9bbbb7" })
hi(0, "StatusDiagnosticInfo", { bg = "#383838", ctermbg = 237, ctermfg = 110, fg = "#83b2c7" })
hi(0, "StatusDiagnosticWarn", { bg = "#383838", ctermbg = 237, ctermfg = 180, fg = "#d9ae7e" })
hi(0, "StatusGreen", { bg = "#383838", ctermbg = 237 })
hi(0, "StatusLine", { ctermfg = 249, fg = "#afb3be" })
hi(0, "StatusLineNC", { ctermfg = 242, fg = "#696e7b" })
hi(0, "StatusLsp", { bg = "#383838", ctermbg = 237, ctermfg = 59, fg = "#5a5e68" })
hi(0, "StatusMagenta", { bg = "#383838", ctermbg = 237, ctermfg = 139, fg = "#ad90c1" })
hi(0, "StatusRed", { bg = "#383838", ctermbg = 237 })
hi(0, "String", { ctermfg = 144, fg = "#a3be8c" })
hi(0, "TabLine", { ctermfg = 246, fg = "#8c909c" })
hi(0, "TabLineSel", { ctermfg = 248, fg = "#a5aab3" })
hi(0, "Title", { ctermfg = 146, fg = "#9cb7cf" })
hi(0, "Todo", { ctermfg = 240, fg = "#535562" })
hi(0, "Type", { ctermfg = 250, fg = "#bdbfc2" })
hi(0, "VertSplit", { ctermfg = 235, fg = "#222630" })
hi(0, "Visual", { bg = "#31374a", ctermbg = 237 })
hi(0, "WarningMsg", { ctermfg = 180, fg = "#d9ae7e" })

-- Terminal colors
local g = vim.g

g.terminal_color_0 = "#1b1f29"
g.terminal_color_1 = "#e16481"
g.terminal_color_2 = "#a3be8c"
g.terminal_color_3 = "#d9ae7e"
g.terminal_color_4 = "#caced9"
g.terminal_color_5 = "#be9cc6"
g.terminal_color_6 = "#83b2c7"
g.terminal_color_7 = "#d7d8dc"
g.terminal_color_8 = "#1b1f29"
g.terminal_color_9 = "#e16481"
g.terminal_color_10 = "#a3be8c"
g.terminal_color_11 = "#d9ae7e"
g.terminal_color_12 = "#caced9"
g.terminal_color_13 = "#be9cc6"
g.terminal_color_14 = "#83b2c7"
g.terminal_color_15 = "#d7d8dc"
