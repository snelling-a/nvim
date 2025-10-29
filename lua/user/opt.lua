vim.g.mapleader = ","
vim.g.maplocalleader = " "

local Icons = require("icons")

vim.cmd("filetype plugin indent on")

vim.schedule(function()
	vim.o.clipboard = "unnamedplus"
end)

-- vim.o.autocomplete = true
vim.o.autoindent = true
vim.o.autowrite = true
vim.o.backup = false
vim.o.breakindent = true
vim.o.breakindentopt = "list:-1"
vim.o.colorcolumn = "+1"
vim.o.complete = ".,w,b,u,kspell"
vim.opt.completeopt = { "popup", "menuone", "noselect", "fuzzy" }
vim.o.conceallevel = 2
vim.o.confirm = true
vim.o.copyindent = true
vim.o.cursorline = true
vim.o.cursorlineopt = "screenline,number"
vim.o.diffopt = "internal,filler,closeoff,indent-heuristic,linematch:60,algorithm:histogram"
vim.o.expandtab = true
vim.o.findfunc = "v:lua.require'user.find'.findfunc"
vim.opt.fillchars = Icons.fillchars
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldmethod = "expr"
vim.o.foldnestmax = 10
vim.o.foldtext = ""
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]
vim.o.formatoptions = "jlnqr1"
vim.o.ignorecase = true
vim.o.inccommand = "split"
vim.o.infercase = true
vim.o.iskeyword = "@,48-57,_,192-255,-"
vim.o.jumpoptions = "view"
vim.o.laststatus = 3
vim.o.linebreak = true
vim.o.list = true
vim.opt.listchars = Icons.listchars
vim.o.mouse = "a"
vim.o.number = true
vim.opt.path:append({ "**" })
vim.o.pumblend = 10
vim.o.pumborder = "rounded"
vim.o.pumheight = 10
vim.o.quickfixtextfunc = "{info -> v:lua.require'user.qf'.quickfixtextfunction(info)}"
vim.o.relativenumber = true
vim.o.ruler = false
vim.opt.runtimepath:append(vim.env.HOMEBREW_PREFIX .. "/bin/fzf")
vim.o.scrolloff = 10
vim.o.shada = "'100,<50,s10,:1000,/100,@100,h"
vim.o.shiftround = true
vim.o.shiftwidth = 2
vim.o.shortmess = "loOstTWIcCF"
vim.o.showmode = false
vim.o.sidescrolloff = 8
vim.o.signcolumn = "yes"
vim.o.smartcase = true
vim.o.smartindent = true
vim.o.smoothscroll = true
vim.o.spell = true
vim.o.spellfile = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"
vim.opt.spelloptions = { "camel", "noplainbuffer" }
vim.opt.spellsuggest = { "best", 9 }
vim.o.splitbelow = true
vim.o.splitkeep = "screen"
vim.o.splitright = true
vim.o.swapfile = false
vim.o.switchbuf = "usetab"
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.timeoutlen = vim.g.vscode and 1000 or 300
vim.o.title = true
vim.o.titlestring = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
vim.o.undofile = true
vim.o.undolevels = 10000
vim.o.updatetime = 200
vim.o.virtualedit = "block"
vim.opt.wildmode = { "longest:full", "full" }
vim.o.winborder = "rounded"
vim.o.winminwidth = 10
vim.o.wrap = false
vim.o.writebackup = false

vim.opt.statuscolumn = "%!v:lua.require'user.statuscolumn'.get()"
local group = require("user.autocmd").augroup("format.options")
vim.api.nvim_create_autocmd({ "FileType" }, {
	group = group,
	callback = function()
		vim.cmd("setlocal formatoptions-=c formatoptions-=o")
	end,
	desc = "Ensure proper 'formatoptions'",
})
