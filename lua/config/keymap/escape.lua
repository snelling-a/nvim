local Util = require("config.util")

local cmd = vim.cmd

local function escape() Util.feedkeys("<Esc>", "i", true) end

Util.imap("jj", function() escape() end, {
	desc = "Go to normal mode",
})

Util.imap("jk", function()
	escape()

	if vim.bo.buftype == "" then
		cmd.update()
	end
end, {
	desc = "Write and go to normal mode",
})

Util.map(
	{
		"c",
		"v",
		"x",
	},
	"jk",
	escape,
	{
		desc = "Escape to normal mode",
	}
)
