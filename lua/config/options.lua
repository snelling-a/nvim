vim.g.mapleader = ","

vim.cmd("filetype plugin indent on")
if vim.fn.exists("syntax_on") ~= 1 then
	vim.cmd("syntax enable")
end
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

vim.o.breakindent = true
vim.o.breakindentopt = "list:-1"
vim.o.colorcolumn = "+1"
vim.o.complete = "o,.,w,b,kspell"
vim.o.completeopt = "menuone,noselect,fuzzy,popup"
vim.o.copyindent = true
vim.o.cursorline = true
vim.o.cursorlineopt = "screenline,number"
vim.o.expandtab = true
vim.o.fillchars = "eob: ,fold: "
vim.o.foldlevel = 10
vim.o.foldmethod = "indent"
vim.o.foldnestmax = 10
vim.o.foldtext = ""
vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]
vim.o.formatoptions = "rqnl1j"
vim.o.ignorecase = true
vim.o.inccommand = "split"
vim.o.incsearch = true
vim.o.infercase = true
vim.o.iskeyword = "@,48-57,_,192-255,-"
vim.o.laststatus = 3
vim.o.linebreak = true
vim.o.list = true
vim.o.listchars = "extends:…,nbsp:␣,precedes:…,tab:  "
vim.o.number = true
vim.o.pumborder = "rounded"
vim.o.pumheight = 10
vim.o.relativenumber = true
vim.o.rulerformat = "%l[%c]/%L %p%%"
vim.o.shada = "'100,<50,s10,:1000,/100,@100,h"
vim.o.shiftwidth = 2
vim.o.shortmess = "CFOTWacto"
vim.o.showmode = false
vim.o.signcolumn = "yes"
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.spelloptions = "camel"
vim.o.splitbelow = true
vim.o.splitkeep = "screen"
vim.o.splitright = true
vim.opt.statusline:prepend("%{%get(b:,'gitsigns_status','')%} ")
vim.o.switchbuf = "usetab"
vim.o.tabstop = 2
vim.o.undofile = true
vim.o.virtualedit = "block"
vim.o.winborder = "rounded"
vim.o.wrap = false

vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		vim.cmd("setlocal formatoptions-=c formatoptions-=o")
	end,
	desc = "Proper 'formatoptions'",
})
