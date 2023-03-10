local utils = require("utils")
local logger = require("utils.logger")

vim.g.mapleader = ","

utils.map({ "c", "v", "x" }, "jk", "<C-c>")
utils.map({ "n", "v" }, ":", ";", { desc = "Command is remapped to `;`" })
vim.keymap.set({ "n", "v" }, ";", ":", { desc = "Command is remapped to `;`" })

local movement_warning = "NO! USE "
utils.nmap("<down>", function() logger.warn({ msg = movement_warning .. "J!" }) end, { desc = "DON'T USE [DOWN]" })
utils.nmap("<left>", function() logger.warn({ msg = movement_warning .. "H!" }) end, { desc = "DON'T USE [LEFT]" })
utils.nmap("<right>", function() logger.warn({ msg = movement_warning .. "L!" }) end, { desc = "DON'T USE [RIGHT]" })
utils.nmap("<up>", function() logger.warn({ msg = movement_warning .. "K!" }) end, { desc = "DON'T USE [Up]" })

utils.map("", "<C-H>", function() vim.cmd.wincmd("h") end, { desc = "Move to Left Window" })
utils.map("", "<C-J>", function() vim.cmd.wincmd("j") end, { desc = "Move to Bottom Window" })
utils.map("", "<C-K>", function() vim.cmd.wincmd("k") end, { desc = "Move to Upper Window" })
utils.map("", "<C-L>", function() vim.cmd.wincmd("l") end, { desc = "Move to Right Window" })

utils.nmap(
	"<C-left>",
	function() vim.cmd.resize({ args = { "-5" }, mods = { vertical = true } }) end,
	{ desc = "Decrease current window width" }
)
utils.nmap(
	"<C-right>",
	function() vim.cmd.resize({ args = { "+5" }, mods = { vertical = true } }) end,
	{ desc = "Increase current window width" }
)
utils.nmap("<C-down>", function() vim.cmd.resize({ args = { "-5" } }) end, { desc = "Decrease current window height" })
utils.nmap("<C-up>", function() vim.cmd.resize({ args = { "+5" } }) end, { desc = "Increase current window height" })

utils.nmap(
	"<leader>s",
	[[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]],
	{ desc = "[S]earch and replace word under the cursor" }
)
utils.nmap("<C-d>", "<C-d>zz", { desc = "Scroll [d]own and center" })
utils.nmap("<C-u>", "<C-u>zz", { desc = "Scroll [u]p and center" })
utils.nmap("<C-z>", "<nop>", { desc = "I'm sure there is a use for this, but for now it's just annoying" })
utils.nmap("<S-TAB>", function() vim.cmd.bprevious() end, { desc = "Go to the previous buffer" })
utils.nmap("<Tab>", function() vim.cmd.bnext() end, { desc = "Go to the next buffer" })
utils.nmap("<leader>,", "``", { desc = "Press `,,` to jump back to the last cursor position." })
utils.nmap("<leader>/", function()
	vim.cmd.nohlsearch()
	logger.info({ msg = "Highlighting cleared" })
end, { desc = "Clear search highlighting" })
utils.nmap("<leader>Y", [["+Y]])
utils.nmap("<leader>fml", function() vim.cmd.CellularAutomaton("make_it_rain") end, { desc = "make it rain" })
utils.nmap("<leader>pv", vim.cmd.Ex, { desc = "Explore directory of current file" })
utils.nmap("<leader>rl", function() utils.reload_modules() end, { desc = "[R]eload [m]odules" })
utils.nmap("<leader>x", function()
	vim.fn.setfperm(vim.fn.expand("%:p"), "rwxr-xr-x")
	logger.info({ msg = string.format("%s made executable", vim.fn.expand("%")), title = "CHMOD!" })
end, { desc = "Make file e[x]ecutable" })
utils.nmap("H", "^", { desc = "Move to the start of line" })
utils.nmap("J", "mzJ`z", { desc = "[J]oin next line to current line" })
utils.nmap("L", "$", { desc = "Move to the end of line" })
utils.nmap("N", "Nzzzv", { desc = "Go to previous search result and center" })
utils.nmap("Q", "<nop>", { desc = "I'm sure there is a use for this, but for now it's just annoying" })
utils.nmap("U", function() vim.cmd.redo() end, { desc = "Better redo" })
utils.nmap("Y", "y$", { desc = "[Y]ank to the end of the line" })
utils.nmap("n", "nzzzv", { desc = "Go to [n]ext search result and center" })

utils.imap("jk", "<Esc>:w<CR>", { desc = "[W]right and go to normal mode" })

utils.vmap("J", ":m '>+1<CR>gv=gv", { desc = "Move lines down" })
utils.vmap("K", ":m '<-2<CR>gv=gv", { desc = "Move lines up" })
