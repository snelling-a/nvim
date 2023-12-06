local feedkeys = require("keymap.util").feedkeys
local map = require("keymap.util").cmap

map("make", function()
	vim.cmd.make({ bang = true })
	feedkeys("<Enter>")
	vim.cmd.copen()
end, { desc = "Make and open the quickfix list" })
