local util = require("config.util")

util.vmap("<", "<gv", {
	desc = "Easy unindent",
})
util.vmap(">", ">gv", {
	desc = "Easy indent",
})
util.vmap("J", ":m '>+1<CR>gv=gv", {
	desc = "Move lines down",
})
util.vmap("K", ":m '<-2<CR>gv=gv", {
	desc = "Move lines up",
})
util.vmap("Q", ":norm @q<CR>", {
	desc = "Use macro stored in the [q] register",
})
