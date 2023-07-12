local logger = require("config.util.logger")
local util = require("config.util")

local cmd = vim.cmd
local fn = vim.fn
local map = vim.keymap.set

vim.g.mapleader = ","

local function escape() util.feedkeys("<Esc>", "i", true) end

local function act_center(lhs)
	util.map({ "n" }, lhs, function()
		util.feedkeys(lhs)
		util.scroll_center()
	end, { desc = "Center screen after " .. lhs })
end
local function center_act(lhs)
	map({ "n" }, lhs, function()
		util.scroll_center()
		util.feedkeys(lhs)
	end, { desc = "Center screen before " .. lhs })
end

act_center("G")
act_center("N")
act_center("n")
act_center("}")
act_center("{")
act_center(")")
act_center("(")
center_act("<C-d>")
center_act("<C-u>")
center_act("A")
center_act("a")
-- center_act("C")
-- center_act("c")
map("n", "c", "zzzvc", { desc = "Center screen after c" })
map("n", "C", "zzzvC", { desc = "Center screen after C" })
center_act("I")
center_act("i")
center_act("O")
center_act("o")
center_act("S")
center_act("s")

map(
	"n",
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/I<Left><Left><Left>]],
	{ desc = "[S]earch and replace word under the cursor" }
)
map({ "n", "v" }, ";", ":", { desc = "Command is remapped to `;`" })

util.imap("jj", function() escape() end, { desc = "Go to normal mode" })
util.imap("jk", function()
	escape()
	if vim.bo.buftype == "" then
		cmd.update()
	end
end, { desc = "Write and go to normal mode" })

util.map({ "c", "v", "x" }, "jk", escape, { desc = "Escape to normal mode" })
util.map({ "n", "v" }, ":", ";", { desc = "Command is remapped to `;`" })

util.mapL(",", "``", { desc = "Press `,,` to jump back to the last cursor position." })
util.mapL("/", function()
	cmd.nohlsearch()
	logger.info("Highlighting cleared")
end, { desc = "Clear search highlighting" })
util.mapL("g", function()
	local conf = logger.confirm({ msg = "Are you sure you want to quit?", type = "Warning" })
	if conf == 1 then
		cmd.quitall()
	end
end, { desc = "[Q]uit all windows" })
util.mapL("x", function()
	fn.setfperm(fn.expand("%:p"), "rwxr-xr-x")
	logger.info({ msg = string.format("%s made executable", fn.expand("%")), title = "CHMOD!" })
end, { desc = "Make file e[x]ecutable" })

util.nmap("<C-z>", "<nop>", { desc = "I'm sure there is a use for this, but for now it's just annoying" })
util.nmap("<S-TAB>", function() cmd.bprevious() end, { desc = "Go to the previous buffer" })
util.nmap("<Tab>", function() cmd.bnext() end, { desc = "Go to the next buffer" })
util.nmap("H", "^", { desc = "Move to the start of line" })
util.nmap("J", "mzJ`z", { desc = "[J]oin next line to current line" })
util.nmap("L", "$", { desc = "Move to the end of line" })
util.nmap("U", function() cmd.redo() end, { desc = "Better redo" })
util.nmap("Y", "y$", { desc = "[Y]ank to the end of the line" })
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

util.vmap("<", "<gv", { desc = "Easy unindent" })
util.vmap(">", ">gv", { desc = "Easy indent" })
util.vmap("J", ":m '>+1<CR>gv=gv", { desc = "Move lines down" })
util.vmap("K", ":m '<-2<CR>gv=gv", { desc = "Move lines up" })
