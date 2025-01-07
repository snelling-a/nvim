vim.g.mapleader = ","
vim.g.maplocalleader = " "

vim.schedule(function()
	vim.opt.clipboard = { "unnamed", "unnamedplus" }
end)

vim.opt.autowrite = true
vim.opt.breakindent = true
vim.opt.conceallevel = 2
vim.opt.confirm = true
vim.opt.cursorline = true
vim.opt.diffopt:append({ "vertical" })
vim.opt.expandtab = true
vim.opt.fillchars = Config.icons.fillchars
vim.opt.foldexpr = "v:lua.vim.lsp.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.foldmethod = "expr"
vim.opt.foldnestmax = 10
vim.opt.foldtext = ""
vim.opt.ignorecase = true
vim.opt.laststatus = 3
vim.opt.linebreak = true
vim.opt.list = true
vim.opt.listchars = Config.icons.listchars
vim.opt.number = true
vim.opt.pumblend = 10
vim.opt.pumheight = 10
vim.opt.relativenumber = true
vim.opt.runtimepath:append(vim.env.HOMEBREW_PREFIX .. "/bin/fzf")
vim.opt.scrolloff = 4
vim.opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
vim.opt.shiftround = true
vim.opt.shiftwidth = 2
vim.opt.showmode = false
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.spell = true
vim.opt.spellfile = spellfile
vim.opt.spelloptions = { "camel", "noplainbuffer" }
vim.opt.spelloptions:append("noplainbuffer")
vim.opt.spellsuggest = { "best", 9 }
vim.opt.splitbelow = true
vim.opt.splitkeep = "screen"
vim.opt.splitright = true
vim.opt.tabstop = 2
vim.opt.termguicolors = true
vim.opt.timeoutlen = vim.g.vscode and 1000 or 300
vim.opt.undofile = true
vim.opt.undolevels = 10000
vim.opt.updatetime = 200
vim.opt.virtualedit = "block"
vim.opt.wildmode = "longest:full,full"
vim.opt.winminwidth = 10
vim.opt.wrap = false

vim.opt.shortmess:append({
	c = true, -- don't give ins-completion-menu messages
	I = true, -- don't give the intro message when starting Vim
	W = true, --	don't give "written" or "[w]" when writing a file
})
vim.opt.shortmess:remove({
	O = true, -- message for reading a file overwrites any previous message; also for quickfix message (e.g., ":cn")
})
