if vim.g.bool_loaded then
	return
end
vim.g.bool_loaded = true

local Bool = require("user.bool")

vim.keymap.set("n", "!", Bool.flip_next, { desc = "Flip word forward" })
vim.keymap.set("n", "!!", Bool.flip_prev, { desc = "Flip word backward" })
