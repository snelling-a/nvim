local Deadcolumn = { "Bekaboo/deadcolumn.nvim" }

Deadcolumn.event = "BufAdd"

Deadcolumn.opts = {
	blending = { hlgroup = { "ColorColumn", "background" }, threshold = 0 },
	warning = { colorcode = vim.g.base08 },
}

return Deadcolumn
