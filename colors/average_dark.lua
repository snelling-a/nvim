-- Made with 'mini.colors' module of https://github.com/echasnovski/mini.nvim

if vim.g.colors_name ~= nil then
	vim.cmd("highlight clear")
end
vim.g.colors_name = "average_dark"

-- Highlight groups
local hi = vim.api.nvim_set_hl

hi(0, "Character", { ctermfg = 144, fg = "#a1b089" })
hi(0, "CmpItemAbbrDefault", { ctermfg = 252, fg = "#cbcfd8" })
hi(0, "CmpItemAbbrDeprecatedDefault", { ctermfg = 242, fg = "#6a6e7a" })
hi(0, "CmpItemAbbrMatchDefault", { ctermfg = 252, fg = "#cbcfd8" })
hi(0, "CmpItemAbbrMatchFuzzyDefault", { ctermfg = 252, fg = "#cbcfd8" })
hi(0, "CmpItemKindDefault", { ctermfg = 249, fg = "#adb5c4" })
hi(0, "CmpItemMenuDefault", { ctermfg = 252, fg = "#cbcfd8" })
hi(0, "Comment", { ctermfg = 242, fg = "#6a6e7a" })
hi(0, "Constant", { ctermfg = 250, fg = "#cbbaad" })
hi(0, "CursorLine", { bg = "#2a2e39", ctermbg = 236 })
hi(0, "CursorLineNr", { ctermfg = 251, fg = "#bfc2d0" })
hi(0, "DiagnosticError", { ctermfg = 168, fg = "#e05f7a" })
hi(0, "DiagnosticHint", { ctermfg = 109, fg = "#8eb6b1" })
hi(0, "DiagnosticInfo", { ctermfg = 110, fg = "#81aece" })
hi(0, "DiagnosticWarn", { ctermfg = 180, fg = "#ddae74" })
hi(0, "Directory", { ctermfg = 110, fg = "#8fb1d7" })
hi(0, "Error", { ctermfg = 168, fg = "#df6486" })
hi(0, "FoldColumn", { ctermfg = 243, fg = "#747886" })
hi(0, "Folded", { ctermfg = 244, fg = "#788191" })
hi(0, "Function", { ctermfg = 146, fg = "#97b8dc" })
hi(0, "GitSignsStagedAdd", { ctermfg = 23, fg = "#435b42" })
hi(0, "GitSignsStagedAddNr", { ctermfg = 23, fg = "#435b42" })
hi(0, "HLChunk1", { ctermfg = 173, fg = "#dc9656" })
hi(0, "HLChunk2", { ctermfg = 131, fg = "#ab4642" })
hi(0, "HLLine_num1", { ctermfg = 173, fg = "#dc9656" })
hi(0, "Identifier", { ctermfg = 249, fg = "#b2b0b4" })
hi(0, "Keyword", { ctermfg = 140, fg = "#a193ca" })
hi(0, "LineNr", { ctermfg = 241, fg = "#606676" })
hi(0, "MoreMsg", { ctermfg = 110, fg = "#82aee2" })
hi(0, "NonText", { ctermfg = 240, fg = "#575b67" })
hi(0, "Normal", { bg = "#1a1d26", ctermbg = 234, ctermfg = 188, fg = "#d5d7dd" })
hi(0, "Operator", { ctermfg = 145, fg = "#a1acc8" })
hi(0, "Pmenu", { bg = "#252935", ctermbg = 235, ctermfg = 252, fg = "#cbcfd8" })
hi(0, "PmenuSel", { bg = "#444d69", ctermbg = 239 })
hi(0, "PreProc", { ctermfg = 146, fg = "#c39ccb" })
hi(0, "Question", { ctermfg = 110, fg = "#94b2c6" })
hi(0, "Special", { ctermfg = 249, fg = "#adb5c4" })
hi(0, "SpecialKey", { ctermfg = 242, fg = "#636873" })
hi(0, "Statement", { ctermfg = 140, fg = "#ac85c7" })
hi(0, "StatusBlue", { bg = "#383838", ctermbg = 237, ctermfg = 146, fg = "#9bb7d0" })
hi(0, "StatusCyan", { bg = "#383838", ctermbg = 237, ctermfg = 243, fg = "#747886" })
hi(0, "StatusDiagnosticError", { bg = "#383838", ctermbg = 237, ctermfg = 168, fg = "#e05f7a" })
hi(0, "StatusDiagnosticHint", { bg = "#383838", ctermbg = 237, ctermfg = 109, fg = "#8eb6b1" })
hi(0, "StatusDiagnosticInfo", { bg = "#383838", ctermbg = 237, ctermfg = 110, fg = "#81aece" })
hi(0, "StatusDiagnosticWarn", { bg = "#383838", ctermbg = 237, ctermfg = 180, fg = "#ddae74" })
hi(0, "StatusGreen", { bg = "#383838", ctermbg = 237 })
hi(0, "StatusLine", { ctermfg = 249, fg = "#b1b5c0" })
hi(0, "StatusLineNC", { ctermfg = 243, fg = "#6d717e" })
hi(0, "StatusLsp", { bg = "#383838", ctermbg = 237, ctermfg = 240, fg = "#575b67" })
hi(0, "StatusMagenta", { bg = "#383838", ctermbg = 237, ctermfg = 140, fg = "#b593ce" })
hi(0, "StatusRed", { bg = "#383838", ctermbg = 237 })
hi(0, "String", { ctermfg = 144, fg = "#a1bb85" })
hi(0, "TabLine", { ctermfg = 247, fg = "#979ca7" })
hi(0, "TabLineSel", { ctermfg = 243, fg = "#70757d" })
hi(0, "Title", { ctermfg = 146, fg = "#9bb7d0" })
hi(0, "Todo", { ctermfg = 238, fg = "#44444f" })
hi(0, "Type", { ctermfg = 250, fg = "#b6c1c2" })
hi(0, "VertSplit", { ctermfg = 234, fg = "#1d2029" })
hi(0, "Visual", { bg = "#32384a", ctermbg = 237 })
hi(0, "WarningMsg", { ctermfg = 180, fg = "#ddae74" })

-- Terminal colors
local g = vim.g

g.terminal_color_0 = "#1a1d26"
g.terminal_color_1 = "#cbbaad"
g.terminal_color_2 = "#a1bb85"
g.terminal_color_3 = "#ddae74"
g.terminal_color_4 = "#d5d7dd"
g.terminal_color_5 = "#c39ccb"
g.terminal_color_6 = "#b6c1c2"
g.terminal_color_7 = "#d5d7dd"
g.terminal_color_8 = "#1a1d26"
g.terminal_color_9 = "#cbbaad"
g.terminal_color_10 = "#a1bb85"
g.terminal_color_11 = "#ddae74"
g.terminal_color_12 = "#d5d7dd"
g.terminal_color_13 = "#c39ccb"
g.terminal_color_14 = "#b6c1c2"
g.terminal_color_15 = "#d5d7dd"
