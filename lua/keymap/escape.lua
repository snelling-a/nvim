local Keymap = require("keymap.util")

local cmd = vim.cmd

local function escape()
	Keymap.feedkeys("<Esc>", "i", true)
end

Keymap.imap("jj", escape, { desc = "Go to normal mode" })

Keymap.imap("jk", function()
	escape()

	if require("util").is_modifiable() then
		cmd.update()
	end
end, { desc = "Write and go to normal mode" })

Keymap.map({ "c", "v", "x" }, "jk", escape, { desc = "Escape to normal mode" })
