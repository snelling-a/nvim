local map = require("config.util").vmap

map("<", "<gv", {
	desc = "Easy unindent",
})
map(">", ">gv", {
	desc = "Easy indent",
})
map("J", ":m '>+1<CR>gv=gv", {
	desc = "Move lines down",
})
map("K", ":m '<-2<CR>gv=gv", {
	desc = "Move lines up",
})
