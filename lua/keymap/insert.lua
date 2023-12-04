local Keymap = require("keymap.util")
local map = Keymap.imap

map(",", ",<c-g>u", { desc = "Create undo breakpoint after '.'" })
map(".", ".<c-g>u", { desc = "Create undo breakpoint after '.'" })
map(";", ";<c-g>u", { desc = "Create undo breakpoint after '.'" })
