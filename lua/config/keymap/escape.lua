local util = require("config.util")

local cmd = vim.cmd

local function escape() util.feedkeys("<Esc>", "i", true) end

util.imap("jj", function() escape() end, {
	desc = "Go to normal mode",
})

util.imap("jk", function()
	escape()

	if vim.bo.buftype == "" then
		cmd.update()
	end
end, {
	desc = "Write and go to normal mode",
})

util.map(
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
