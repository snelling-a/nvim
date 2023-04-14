local logger = require("utils.logger")
local utils = require("utils")

local cmd = vim.cmd
local fn = vim.fn
local map = vim.keymap.set

vim.g.mapleader = ","

local function escape() utils.feedkeys("<Esc>", "i", true) end

utils.map({ "c", "v", "x" }, "jk", escape, { desc = "Escape to normal mode" })
utils.map({ "n", "v" }, ":", ";", { desc = "Command is remapped to `;`" })
map({ "n", "v" }, ";", ":", { desc = "Command is remapped to `;`" })

local movement_warning = "NO! USE "
utils.nmap("<down>", function() logger.warn({ msg = movement_warning .. "J!" }) end, { desc = "DON'T USE [DOWN]" })
utils.nmap("<left>", function() logger.warn({ msg = movement_warning .. "H!" }) end, { desc = "DON'T USE [LEFT]" })
utils.nmap("<right>", function() logger.warn({ msg = movement_warning .. "L!" }) end, { desc = "DON'T USE [RIGHT]" })
utils.nmap("<up>", function() logger.warn({ msg = movement_warning .. "K!" }) end, { desc = "DON'T USE [Up]" })

utils.map("", "<C-H>", function() cmd.wincmd("h") end, { desc = "Move to Left Window" })
utils.map("", "<C-J>", function() cmd.wincmd("j") end, { desc = "Move to Bottom Window" })
utils.map("", "<C-K>", function() cmd.wincmd("k") end, { desc = "Move to Upper Window" })
utils.map("", "<C-L>", function() cmd.wincmd("l") end, { desc = "Move to Right Window" })

utils.nmap(
	"<C-left>",
	function() cmd.resize({ args = { "-5" }, mods = { vertical = true } }) end,
	{ desc = "Decrease current window width" }
)
utils.nmap(
	"<C-right>",
	function() cmd.resize({ args = { "+5" }, mods = { vertical = true } }) end,
	{ desc = "Increase current window width" }
)
utils.nmap("<C-down>", function() cmd.resize({ args = { "-5" } }) end, { desc = "Decrease current window height" })
utils.nmap("<C-up>", function() cmd.resize({ args = { "+5" } }) end, { desc = "Increase current window height" })

map(
	"n",
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "[S]earch and replace word under the cursor" }
)
utils.nmap("<C-u>", function()
	utils.feedkeys("<C-u>")
	utils.scroll_center()
end, { desc = "Scroll [u]p and center" })
utils.nmap("<C-z>", "<nop>", { desc = "I'm sure there is a use for this, but for now it's just annoying" })
utils.nmap("<S-TAB>", function() cmd.bprevious() end, { desc = "Go to the previous buffer" })
utils.nmap("<Tab>", function() cmd.bnext() end, { desc = "Go to the next buffer" })
utils.nmap("<leader>,", "``", { desc = "Press `,,` to jump back to the last cursor position." })
utils.nmap("<leader>/", function()
	cmd.nohlsearch()
	logger.info({ msg = "Highlighting cleared" })
end, { desc = "Clear search highlighting" })
utils.nmap("<leader>fml", function() cmd.CellularAutomaton("make_it_rain") end, { desc = "make it rain" })
utils.nmap("<leader>rl", function() utils.reload_modules() end, { desc = "[R]eload [m]odules" })
utils.nmap("<leader>x", function()
	fn.setfperm(fn.expand("%:p"), "rwxr-xr-x")
	logger.info({ msg = string.format("%s made executable", fn.expand("%")), title = "CHMOD!" })
end, { desc = "Make file e[x]ecutable" })
utils.nmap("H", "^", { desc = "Move to the start of line" })
utils.nmap("J", "mzJ`z", { desc = "[J]oin next line to current line" })
utils.nmap("L", "$", { desc = "Move to the end of line" })
utils.nmap("N", function()
	utils.feedkeys("N")
	utils.scroll_center()
	utils.feedkeys("zv")
end, { desc = "Go to previous search result and center" })
utils.nmap("Q", "<nop>", { desc = "I'm sure there is a use for this, but for now it's just annoying" })
utils.nmap("U", function() cmd.redo() end, { desc = "Better redo" })
utils.nmap("Y", "y$", { desc = "[Y]ank to the end of the line" })
utils.nmap("n", function()
	utils.feedkeys("n")
	utils.scroll_center()
	utils.feedkeys("zv")
end, { desc = "Go to [n]ext search result and center" })

map({ "n", "v" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Move to next visual line" })
map({ "n", "v" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Move to previous visual line" })

utils.imap("jk", function()
	escape()
	if vim.bo.buftype == "" then
		cmd.update()
	end
end, { desc = "Wright and go to normal mode" })
utils.imap("jj", function() escape() end, { desc = "Go to normal mode" })

utils.vmap("J", ":m '>+1<CR>gv=gv", { desc = "Move lines down" })
utils.vmap("K", ":m '<-2<CR>gv=gv", { desc = "Move lines up" })

utils.nmap("<leader>g", function()
	local conf = logger.confirm({ msg = "Are you sure you want to quit?", type = "Warning" })
	if conf == 1 then
		cmd.quit()
	end
end, { desc = "[Q]uit all windows" })
