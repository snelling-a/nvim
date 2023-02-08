local utils = require("utils")

vim.g.mapleader = ","

utils.map({ "n", "v" }, ":", ";", { desc = "Command is remapped to `;`" })
vim.keymap.set({ "n", "v" }, ";", ":", { desc = "Command is remapped to `;`" })

utils.nmap("<down>", function() vim.notify("'NO! USE J!'", vim.log.levels.WARN) end, { desc = "DON'T USE [DOWN]" })
utils.nmap("<left>", function() vim.notify("'NO! USE H!'", vim.log.levels.WARN) end, { desc = "DON'T USE [LEFT]" })
utils.nmap("<right>", function() vim.notify("'NO! USE L!'", vim.log.levels.WARN) end, { desc = "DON'T USE [RIGHT]" })
utils.nmap("<up>", function() vim.notify("'NO! USE K!'", vim.log.levels.WARN) end, { desc = "DON'T USE [Up]" })

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
utils.nmap("<S-TAB>", function() vim.cmd.bprevious() end, { desc = "Go to the previous buffer" })
utils.nmap("<Tab>", function() vim.cmd.bnext() end, { desc = "Go to the next buffer" })
utils.nmap("<leader>,", "``", { desc = "Press `,,` to jump back to the last cursor position." })
utils.nmap("<leader>/", function()
	vim.cmd.nohlsearch()
	vim.notify('"Highlighting cleared"', vim.log.levels.INFO)
end, { desc = "Clear search highlighting" })
utils.nmap("<leader>Y", [["+Y]])
utils.nmap("<leader>fml", function() vim.cmd.CellularAutomaton("make_it_rain") end, { desc = "make it rain" })
utils.nmap("<leader>pv", vim.cmd.Ex, { desc = "Explore directory of current file" })
utils.nmap("<leader>rl", function() utils.reload_modules() end, { desc = "[R]eload [m]odules" })
utils.nmap("<leader>x", function()
	vim.fn.setfperm(vim.fn.expand("%:p"), "rwxr-xr-x")
	vim.notify(string.format("%s made executable", vim.fn.expand("%")), vim.log.levels.INFO, { title = "CHMOD!" })
end, { desc = "Make file e[x]ecutable" })
utils.nmap("H", "^", { desc = "Move to the start of line" })
utils.nmap("J", "mzJ`z", { desc = "[J]oin next line to current line" })
utils.nmap("L", "$", { desc = "Move to the end of line" })
utils.nmap("N", "Nzzzv", { desc = "Go to previous search result and center" })
utils.nmap("Q", "<nop>", { desc = "I'm sure there is a use for this, but for now it's just annoying" })
utils.nmap("U", function() vim.cmd.redo() end, { desc = "Better redo" })
utils.nmap("Y", "y$", { desc = "[Y]ank to the end of the line" })
utils.nmap("n", "nzzzv", { desc = "Go to [n]ext search result and center" })

utils.cmap("jk", "<C-c>")

utils.imap("jk", "<Esc>:w<CR>")

utils.vmap("J", ":m '>+1<CR>gv=gv", { desc = "Move lines down" })
utils.vmap("K", ":m '<-2<CR>gv=gv", { desc = "Move lines up" })
