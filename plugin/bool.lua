if vim.g.bool_loaded then
	return
end
vim.g.bool_loaded = true

local flip = require("user.bool")

vim.keymap.set("n", "!", flip.flip_next, { desc = "Flip word forward" })
vim.keymap.set("n", "!!", flip.flip_prev, { desc = "Flip word backward" })
