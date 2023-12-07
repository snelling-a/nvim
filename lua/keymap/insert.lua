local map = require("keymap.util").imap

map(",", ",<c-g>u", { desc = "Create undo breakpoint after '.'" })
map(".", ".<c-g>u", { desc = "Create undo breakpoint after '.'" })
map(";", ";<c-g>u", { desc = "Create undo breakpoint after '.'" })
