local Util = require("config.util")

local v = vim.v

Util.nmap("<C-z>", "<nop>", {
	desc = "I'm sure there is a use for this, but for now it's just annoying",
})
Util.nmap("<S-TAB>", function()
	if Util.are_buffers_listed() then
		vim.cmd([[bprevious]])
	end
end, {
	desc = "Go to the previous buffer",
})
Util.nmap("<Tab>", function()
	if Util.are_buffers_listed() then
		vim.cmd([[bnext]])
	end
end, {
	desc = "Go to the next buffer",
})
Util.nmap("J", "mzJ`z", {
	desc = "[J]oin next line to current line",
})
Util.nmap("H", function()
	if vim.api.nvim_get_option_value("wrap", {
		scope = "local",
	}) then
		cmd.normal("g^")
	else
		cmd.normal("^")
	end
end, {
	desc = "Move to the start of line",
})
Util.nmap("L", function()
	if vim.api.nvim_get_option_value("wrap", {
		scope = "local",
	}) then
		cmd.normal("g$")
	else
		cmd.normal("$")
	end
end, {
	desc = "Move to the end of line",
})
Util.nmap("U", function() vim.cmd([[redo]]) end, {
	desc = "Better redo",
})
Util.nmap("Q", "@q", {
	desc = "Use macro stored in the [q] register",
})
Util.nmap("Y", "y$", {
	desc = "[Y]ank to the end of the line",
})
Util.nmap("j", function()
	if v.count > 0 and v.count >= 3 then
		return ("m'" .. v.count .. "j")
	else
		return "gj"
	end
end, {
	noremap = true,
	expr = true,
	desc = "Move to next visual line",
})
Util.nmap("k", function()
	if v.count > 0 and v.count >= 3 then
		return ("m'" .. v.count .. "k")
	else
		return "gk"
	end
end, {
	noremap = true,
	expr = true,
	desc = "Move to previous visual line",
})
Util.nmap("z<CR>", "zt", {
	desc = "Redraw, line at top of window. Leave the cursor in the same column.",
})
