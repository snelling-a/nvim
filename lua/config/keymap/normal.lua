local util = require("config.util")
local cmd = vim.cmd

util.nmap("<C-z>", "<nop>", {
	desc = "I'm sure there is a use for this, but for now it's just annoying",
})
util.nmap("<S-TAB>", function() cmd.bprevious() end, {
	desc = "Go to the previous buffer",
})
util.nmap("<Tab>", function() cmd.bnext() end, {
	desc = "Go to the next buffer",
})
util.nmap("J", "mzJ`z", {
	desc = "[J]oin next line to current line",
})
util.nmap("H", "g^", {
	desc = "Move to the start of line",
})
util.nmap("L", "g$", {
	desc = "Move to the end of line",
})
util.nmap("U", function() cmd.redo() end, {
	desc = "Better redo",
})
util.nmap("Q", "@q", {
	desc = "Use macro stored in the [q] register",
})
util.nmap("Y", "y$", {
	desc = "[Y]ank to the end of the line",
})
util.nmap("j", function()
	if vim.v.count > 0 and vim.v.count >= 3 then
		return ("m'" .. vim.v.count .. "j")
	else
		return "gj"
	end
end, {
	noremap = true,
	expr = true,
	desc = "Move to next visual line",
})
util.nmap("k", function()
	if vim.v.count > 0 and vim.v.count >= 3 then
		return ("m'" .. vim.v.count .. "k")
	else
		return "gk"
	end
end, {
	noremap = true,
	expr = true,
	desc = "Move to previous visual line",
})
