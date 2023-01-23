local utils = require("utils")

vim.g.mapleader = ","
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

utils.vmap("J", ":m '>+1<CR>gv=gv")
utils.vmap("K", ":m '<-2<CR>gv=gv")

utils.nmap("J", "mzJ`z")
utils.nmap("<C-d>", "<C-d>zz")
utils.nmap("<C-u>", "<C-u>zz")
utils.nmap("n", "nzzzv")
utils.nmap("N", "Nzzzv")

utils.map({ "n", "v" }, "<leader>y", [["+y]])
utils.nmap("<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

utils.imap("<C-c>", "<Esc>")

utils.nmap("Q", "<nop>")
utils.nmap("<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
utils.nmap("<leader>f", vim.lsp.buf.format)

utils.nmap("<C-k>", "<cmd>cnext<CR>zz")
utils.nmap("<C-j>", "<cmd>cprev<CR>zz")
utils.nmap("<leader>k", "<cmd>lnext<CR>zz")
utils.nmap("<leader>j", "<cmd>lprev<CR>zz")
utils.nmap("<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
utils.nmap("<leader>x", "<cmd>!chmod +x %<CR>", { desc = "" })

---- ! DON'T USE THE ARROW KEYS !"
utils.nmap("<up>", ":echo 'NO! USE K!'<CR>")
utils.nmap("<down>", ":echo 'NO! USE J!'<CR>")
utils.nmap("<left>", ":echo 'NO! USE H!'<CR>")
utils.nmap("<right>", ":echo 'NO! USE L!'<CR>")

--  Press ,, to jump back to the last cursor position.
utils.nmap("<leader>,", "``")

--  Type jk to exit insert mode quickly and save.
utils.imap("jk", "<Esc>:w<CR>")
utils.cmap("jk", "<C-c>")

--  Move to the start of line
utils.nmap("H", "^")
--  Move to the end of line
utils.nmap("L", "$")

--  Don't press shift to enter command mode
utils.nmap(";", ":")
utils.vmap(";", ":")
utils.nmap(":", ";")
utils.vmap(":", ";")

--  yank from cursor to the end of line.
utils.nmap("Y", "y$")

--  remap u to <c-r> for easier redo
--  from http://vimbits.com/bits/356
utils.nmap("U", "<c-r>")

--  clear highlighting
utils.nmap("<leader>/", ":noh | echo 'highlighting cleared'<CR>")

--  Easy window navigation
utils.map('', '<C-H>', '<C-w>h')
utils.map('', '<C-J>', '<C-w>j')
utils.map('', '<C-K>', '<C-w>k')
utils.map('', '<C-L>', '<C-w>l')

utils.nmap('<C-down>', ':resize +2<CR>')
utils.nmap('<C-left>', ':vertical resize -2<CR>')
utils.nmap('<C-right>', ':vertical resize +2<CR>')
utils.nmap('<C-up>', ':resize -2<CR>')

utils.nmap('<Tab>', ':bNext<CR>', utils.noreamp)
utils.nmap('<S-TAB>', ':bprevious<CR>', utils.noreamp)
