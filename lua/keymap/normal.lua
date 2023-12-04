local are_buffers_listed = require("util").are_buffers_listed
local map = require("keymap.util").nmap

local cmd = vim.cmd
local v = vim.v

map("<C-z>", "<nop>", { desc = "I'm sure there is a use for this, but for now it's just annoying" })

map("<S-TAB>", function()
	if are_buffers_listed() then
		cmd.bprevious()
	end
end, { desc = "Go to the previous buffer" })

map("<Tab>", function()
	if are_buffers_listed() then
		cmd.bnext()
	end
end, { desc = "Go to the next buffer" })

map("J", "mzJ`z", { desc = "[J]oin next line to current line" })

map("H", function()
	if vim.api.nvim_get_option_value("wrap", { scope = "local" }) then
		cmd.normal("g^")
	else
		cmd.normal("^")
	end
end, { desc = "Move to the start of line" })

map("L", function()
	if vim.api.nvim_get_option_value("wrap", {
		scope = "local",
	}) then
		cmd.normal("g$")
	else
		cmd.normal("$")
	end
end, { desc = "Move to the end of line" })

map("U", cmd.redo, { desc = "Better redo" })

map("j", function()
	if v.count > 0 and v.count >= 3 then
		return ("m'%sj"):format(v.count)
	else
		return "gj"
	end
end, { desc = "Move to next visual line", expr = true, noremap = true })

map("k", function()
	if v.count > 0 and v.count >= 3 then
		return ("m'%sk"):format(v.count)
	else
		return "gk"
	end
end, { desc = "Move to previous visual line", expr = true, noremap = true })

map("z<CR>", "zt", { desc = "Redraw, line at top of window. Leave the cursor in the same column." })
