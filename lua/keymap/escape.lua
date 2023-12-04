local Keymap = require("keymap.util")

local cmd = vim.cmd

local function escape()
	Keymap.feedkeys("<Esc>", "i", true)
end

Keymap.imap("jj", function()
	escape()
end, { desc = "Go to normal mode" })

Keymap.imap("jk", function()
	escape()

	if vim.bo.buftype == "" then
		cmd.update()
	end
end, { desc = "Write and go to normal mode" })

Keymap.map({ "c", "v", "x" }, "jk", escape, { desc = "Escape to normal mode" })
