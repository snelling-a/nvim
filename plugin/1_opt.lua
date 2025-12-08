vim.g.mapleader = ","

vim.o.mousescroll = "ver:25,hor:6"
vim.o.switchbuf = "usetab"
vim.o.undofile = true

vim.o.shada = "'100,<50,s10,:1000,/100,@100,h"

vim.cmd("filetype plugin indent on")
if vim.fn.exists("syntax_on") ~= 1 then
	vim.cmd("syntax enable")
end
vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

vim.o.laststatus = 3
vim.o.autocomplete = true
vim.o.copyindent = true
vim.o.breakindent = true
vim.o.breakindentopt = "list:-1"
vim.o.colorcolumn = "+1"
vim.o.complete = "o,.,w,b,kspell"
vim.o.completeopt = "menuone,noselect,fuzzy,popup"
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
vim.o.incsearch = true
vim.o.infercase = true
vim.o.iskeyword = "@,48-57,_,192-255,-"
vim.o.linebreak = true
vim.o.list = true
vim.o.listchars = "extends:…,nbsp:␣,precedes:…,tab:  "
vim.o.number = true
vim.o.pumborder = "rounded"
vim.o.pumheight = 10
vim.o.shiftwidth = 2
vim.o.shortmess = "CFOSWaco"
vim.o.showmode = false
vim.o.signcolumn = "yes"
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.spelloptions = "camel"
vim.o.splitbelow = true
vim.o.splitkeep = "screen"
vim.o.splitright = true
vim.o.tabstop = 2
vim.o.virtualedit = "block"
vim.o.winborder = "rounded"
vim.o.wrap = false

vim.api.nvim_create_autocmd("FileType", {
	callback = function()
		vim.cmd("setlocal formatoptions-=c formatoptions-=o")
	end,
	desc = "Proper 'formatoptions'",
})

vim.diagnostic.config({
	jump = {
		on_jump = function()
			vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
		end,
	},
	severity_sort = true,
	signs = function()
		return {
			text = {
				[vim.diagnostic.severity.ERROR] = " ",
				[vim.diagnostic.severity.HINT] = " ",
				[vim.diagnostic.severity.INFO] = " ",
				[vim.diagnostic.severity.WARN] = "󱈸",
			},
		}
	end,
	underline = { severity = { min = vim.diagnostic.severity.HINT, max = vim.diagnostic.severity.ERROR } },
	update_in_insert = false,
	virtual_lines = false,
	virtual_text = {
		current_line = true,
		severity = { min = vim.diagnostic.severity.ERROR, max = vim.diagnostic.severity.ERROR },
	},
})

vim.g.netrw_banner = 0
vim.g.netrw_localcopydircmd = "cp -r"
vim.g.netrw_liststyle = 3
vim.g.netrw_winsize = 30
vim.g.netrw_browse_split = 4

require("vim._extui").enable({})
