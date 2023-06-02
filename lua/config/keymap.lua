local logger = require("config.util.logger")
local util = require("config.util")

local cmd = vim.cmd
local fn = vim.fn
local map = vim.keymap.set

vim.g.mapleader = ","

local function escape() util.feedkeys("<Esc>", "i", true) end

util.map({ "c", "v", "x" }, "jk", escape, { desc = "Escape to normal mode" })
util.map({ "n", "v" }, ":", ";", { desc = "Command is remapped to `;`" })
map({ "n", "v" }, ";", ":", { desc = "Command is remapped to `;`" })

map(
	"n",
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/I<Left><Left><Left>]],
	{ desc = "[S]earch and replace word under the cursor" }
)
util.nmap("<C-u>", function()
	util.feedkeys("<C-u>")
	util.scroll_center()
end, { desc = "Scroll [u]p and center" })
util.nmap("<C-z>", "<nop>", { desc = "I'm sure there is a use for this, but for now it's just annoying" })
util.nmap("<S-TAB>", function() cmd.bprevious() end, { desc = "Go to the previous buffer" })
util.nmap("<Tab>", function() cmd.bnext() end, { desc = "Go to the next buffer" })
util.mapL(",", "``", { desc = "Press `,,` to jump back to the last cursor position." })
util.mapL("/", function()
	cmd.nohlsearch()
	logger.info("Highlighting cleared")
end, { desc = "Clear search highlighting" })
util.mapL("x", function()
	fn.setfperm(fn.expand("%:p"), "rwxr-xr-x")
	logger.info({ msg = string.format("%s made executable", fn.expand("%")), title = "CHMOD!" })
end, { desc = "Make file e[x]ecutable" })
util.nmap("H", "^", { desc = "Move to the start of line" })
util.nmap("J", "mzJ`z", { desc = "[J]oin next line to current line" })
util.nmap("L", "$", { desc = "Move to the end of line" })
util.nmap("N", function()
	util.feedkeys("N")
	util.scroll_center()
	util.feedkeys("zv")
end, { desc = "Go to previous search result and center" })
util.nmap("U", function() cmd.redo() end, { desc = "Better redo" })
util.nmap("Y", "y$", { desc = "[Y]ank to the end of the line" })
util.nmap("n", function()
	util.feedkeys("n")
	util.scroll_center()
	util.feedkeys("zv")
end, { desc = "Go to [n]ext search result and center" })

util.nmap("j", function()
	if vim.v.count > 0 and vim.v.count >= 3 then
		return ("m'" .. vim.v.count .. "j")
	else
		return "gj"
	end
end, { noremap = true, expr = true, desc = "Move to next visual line" })
util.nmap("k", function()
	if vim.v.count > 0 and vim.v.count >= 3 then
		return ("m'" .. vim.v.count .. "k")
	else
		return "gk"
	end
end, { noremap = true, expr = true, desc = "Move to previous visual line" })

util.imap("jk", function()
	escape()
	if vim.bo.buftype == "" then
		cmd.update()
	end
end, { desc = "Write and go to normal mode" })
util.imap("jj", function() escape() end, { desc = "Go to normal mode" })

util.vmap("<", "<gv", { desc = "Easy unindent" })
util.vmap(">", ">gv", { desc = "Easy indent" })
util.vmap("J", ":m '>+1<CR>gv=gv", { desc = "Move lines down" })
util.vmap("K", ":m '<-2<CR>gv=gv", { desc = "Move lines up" })

util.mapL("g", function()
	local conf = logger.confirm({ msg = "Are you sure you want to quit?", type = "Warning" })
	if conf == 1 then
		cmd.quitall()
	end
end, { desc = "[Q]uit all windows" })
