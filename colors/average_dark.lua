-- Made with 'mini.colors' module of https://github.com/echasnovski/mini.nvim

if vim.g.colors_name ~= nil then
	vim.cmd("highlight clear")
end
vim.g.colors_name = "average_dark"

-- Highlight groups
local hi = vim.api.nvim_set_hl

hi(0, "@constructor", { ctermfg = 110, fg = "#95b3ca" })
hi(0, "@keyword.operator", { ctermfg = 146, fg = "#b1abc3" })
hi(0, "@parameter", { ctermfg = 250, fg = "#b8b8b8" })
hi(0, "@punctuation.bracket", { ctermfg = 249, fg = "#adb3c1" })
hi(0, "@punctuation.special", { ctermfg = 250, fg = "#90c3d1" })
hi(0, "@string.escape", { ctermfg = 145, fg = "#a7afc2" })
hi(0, "@variable", { ctermfg = 188, fg = "#d5d7de" })
hi(0, "@variable.builtin", { ctermfg = 174, fg = "#e07993" })
hi(0, "Character", { ctermfg = 144, fg = "#a7b586" })
hi(0, "CmpItemAbbrDefault", { ctermfg = 252, fg = "#cdd0d7" })
hi(0, "CmpItemAbbrDeprecatedDefault", { ctermfg = 242, fg = "#696e7b" })
hi(0, "CmpItemAbbrMatchDefault", { ctermfg = 252, fg = "#cdd0d7" })
hi(0, "CmpItemAbbrMatchFuzzyDefault", { ctermfg = 252, fg = "#cdd0d7" })
hi(0, "CmpItemKindDefault", { ctermfg = 249, fg = "#afb6c1" })
hi(0, "CmpItemMenuDefault", { ctermfg = 252, fg = "#cdd0d7" })
hi(0, "ColorColumn", { bg = "#252830", ctermbg = 235 })
hi(0, "Comment", { ctermfg = 242, fg = "#696e7b" })
hi(0, "Constant", { ctermfg = 180, fg = "#ddb9a1" })
hi(0, "CursorColumn", { bg = "#2c2f38", ctermbg = 236 })
hi(0, "CursorLine", { bg = "#2c2f38", ctermbg = 236 })
hi(0, "CursorLineNr", { ctermfg = 251, fg = "#bec2cd" })
hi(0, "DiagnosticError", { ctermfg = 168, fg = "#df5974" })
hi(0, "DiagnosticHint", { ctermfg = 109, fg = "#81b0aa" })
hi(0, "DiagnosticInfo", { ctermfg = 110, fg = "#7faad5" })
hi(0, "DiagnosticUnderlineError", { undercurl = true })
hi(0, "DiagnosticUnderlineHint", { undercurl = true })
hi(0, "DiagnosticUnderlineInfo", { undercurl = true })
hi(0, "DiagnosticUnderlineWarn", { undercurl = true })
hi(0, "DiagnosticWarn", { ctermfg = 179, fg = "#e1ae69" })
hi(0, "Directory", { ctermfg = 110, fg = "#8eb5e6" })
hi(0, "Error", { ctermfg = 168, fg = "#de6387" })
hi(0, "FoldColumn", { ctermfg = 243, fg = "#717581" })
hi(0, "Folded", { ctermfg = 244, fg = "#78818f" })
hi(0, "Function", { ctermfg = 110, fg = "#90b6e7" })
hi(0, "GitSignsStagedAdd", { ctermfg = 23, fg = "#435a3f" })
hi(0, "GitSignsStagedAddNr", { ctermfg = 23, fg = "#435a3f" })
hi(0, "GitSignsStagedDelete", { ctermfg = 238, fg = "#6d2e3a" })
hi(0, "GitSignsStagedDeleteNr", { ctermfg = 238, fg = "#6d2e3a" })
hi(0, "GitSignsStagedTopdelete", { ctermfg = 238, fg = "#6d2e3a" })
hi(0, "GitSignsStagedTopdeleteNr", { ctermfg = 238, fg = "#6d2e3a" })
hi(0, "Identifier", { ctermfg = 249, fg = "#b6b3b4" })
hi(0, "Keyword", { ctermfg = 140, fg = "#b08ad2" })
hi(0, "LeapLabelPrimary", { ctermfg = 233, fg = "#161616" })
hi(0, "LeapLabelSecondary", { ctermfg = 233, fg = "#161616" })
hi(0, "LeapLabelSelected", { bg = "#ff00ff", ctermbg = 201, ctermfg = 16, fg = "#000000", nocombine = true })
hi(0, "LeapMatch", { ctermfg = 223, fg = "#e9deb0" })
hi(0, "LineNr", { ctermfg = 242, fg = "#696e7a" })
hi(0, "LspReferenceRead", { bg = "#3c4252", ctermbg = 238 })
hi(0, "LspReferenceText", { bg = "#3c4252", ctermbg = 238 })
hi(0, "LspReferenceWrite", { bg = "#3c4252", ctermbg = 238 })
hi(0, "MoreMsg", { ctermfg = 110, fg = "#80ace7" })
hi(0, "NonText", { ctermfg = 240, fg = "#545965" })
hi(0, "Normal", { bg = "#191c23", ctermbg = 234, ctermfg = 188, fg = "#d4d7de" })
hi(0, "Operator", { ctermfg = 146, fg = "#a4afcb" })
hi(0, "Pmenu", { bg = "#272a32", ctermbg = 235, ctermfg = 252, fg = "#cdd0d7" })
hi(0, "PmenuSel", { bg = "#47516c", ctermbg = 239 })
hi(0, "PreProc", { ctermfg = 146, fg = "#c89cd0" })
hi(0, "Question", { ctermfg = 110, fg = "#91aec5" })
hi(0, "SignColumn", { ctermfg = 244, fg = "#7c818d" })
hi(0, "Special", { ctermfg = 249, fg = "#afb6c1" })
hi(0, "SpecialKey", { ctermfg = 59, fg = "#585e6a" })
hi(0, "Statement", { ctermfg = 140, fg = "#ae8ad9" })
hi(0, "StatusBlue", { bg = "#383838", ctermbg = 237, ctermfg = 146, fg = "#9ab7d0" })
hi(0, "StatusCyan", { bg = "#383838", ctermbg = 237, ctermfg = 243, fg = "#717581" })
hi(0, "StatusGreen", { bg = "#383838", ctermbg = 237 })
hi(0, "StatusLine", { bg = "#161922", ctermbg = 234, ctermfg = 250, fg = "#b4b8c2" })
hi(0, "StatusLineNC", { ctermfg = 243, fg = "#717581" })
hi(0, "StatusMagenta", { bg = "#383838", ctermbg = 237 })
hi(0, "StatusRed", { bg = "#383838", ctermbg = 237 })
hi(0, "String", { ctermfg = 144, fg = "#9eb87f" })
hi(0, "Substitute", { bg = "#eb6e85", ctermbg = 204, ctermfg = 235, fg = "#23262d" })
hi(0, "TabLine", { ctermfg = 248, fg = "#a3a8b2" })
hi(0, "TabLineSel", { bg = "#707584", ctermbg = 243, ctermfg = 238, fg = "#3e4249" })
hi(0, "Title", { ctermfg = 146, fg = "#9ab7d0" })
hi(0, "Todo", { ctermfg = 236, fg = "#34343d" })
hi(0, "Type", { ctermfg = 250, fg = "#afc2c1" })
hi(0, "VertSplit", { ctermfg = 234, fg = "#181a22" })
hi(0, "Visual", { bg = "#32394a", ctermbg = 237 })
hi(0, "WarningMsg", { ctermfg = 179, fg = "#e1ae69" })

-- Terminal colors
local g = vim.g

g.terminal_color_0 = "#191c23"
g.terminal_color_1 = "#ddb9a1"
g.terminal_color_2 = "#9eb87f"
g.terminal_color_3 = "#e9deb0"
g.terminal_color_4 = "#d4d7de"
g.terminal_color_5 = "#ff00ff"
g.terminal_color_6 = "#90c3d1"
g.terminal_color_7 = "#d4d7de"
g.terminal_color_8 = "#191c23"
g.terminal_color_9 = "#ddb9a1"
g.terminal_color_10 = "#9eb87f"
g.terminal_color_11 = "#e9deb0"
g.terminal_color_12 = "#d4d7de"
g.terminal_color_13 = "#ff00ff"
g.terminal_color_14 = "#90c3d1"
g.terminal_color_15 = "#d4d7de"
