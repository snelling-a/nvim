local vmap = require("config.util").vmap

vmap("<", "<gv", {
	desc = "Easy unindent",
})
vmap(">", ">gv", {
	desc = "Easy indent",
})
vmap("J", ":m '>+1<CR>gv=gv", {
	desc = "Move lines down",
})
vmap("K", ":m '<-2<CR>gv=gv", {
	desc = "Move lines up",
})
