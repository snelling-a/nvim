local map = require("keymap.util").vmap

map("<", "<gv", { desc = "Easy unindent" })

map(">", ">gv", { desc = "Easy indent" })

map("J", ":move '>+1<CR>gv=gv", { desc = "Move lines down" })

map("K", ":move '<-2<CR>gv=gv", { desc = "Move lines up" })
