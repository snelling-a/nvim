vim.g.mapleader = ","
vim.g.maplocalleader = "\\"

local opt = vim.opt

opt.autowrite = true
opt.breakindent = true
opt.clipboard = { "unnamed", "unnamedplus" }
opt.concealcursor = "nc"
opt.conceallevel = 3
opt.confirm = true
opt.cpoptions:append("l")
opt.diffopt:append({ "hiddenoff", "vertical" })
opt.expandtab = true
opt.fileencoding = "utf-8"
opt.fileformats:append("mac")
opt.fillchars = require("ui.icons").fillchars
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevelstart = 2
opt.foldmethod = "expr"
opt.foldtext = "v:lua.require'ui.fold'.text()"
opt.gdefault = true
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --hidden --vimgrep --smart-case"
opt.guifont = "Iosevka Nerd Font Mono"
opt.ignorecase = true
opt.inccommand = "split"
opt.isfname:append("@-@") -- include all characters where isalpha() returns TRUE are
opt.linebreak = true
opt.list = true
opt.listchars = require("ui.icons").listchars
opt.modelines = 2
opt.mouse = "a"
opt.number = true
opt.path:append("**")
opt.pumblend = 10
opt.pumheight = 10
opt.runtimepath:append("/usr/local/opt/fzf")
opt.scrolloff = 10
opt.shada = { "!", "'1000", "<50", "s10", "h" }
opt.shell = "/usr/local/bin/bash"
opt.shiftround = true
opt.shiftwidth = 4
opt.showbreak = string.rep(" ", 4) --[[@as vim.opt.showbreak]]
opt.showcmd = false
opt.sidescrolloff = 10
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.softtabstop = 4
opt.spell = true
opt.spelllang = "en_us"
opt.spelllang = { "en" }
opt.spelloptions = { "camel", "noplainbuffer" }
opt.spellsuggest = { "best", 9 }
opt.splitbelow = true
opt.splitkeep = "screen"
opt.splitright = true
opt.switchbuf = "split"
opt.synmaxcol = 500
opt.tabstop = 4
opt.termguicolors = true
opt.timeoutlen = 300
opt.ttimeoutlen = 20
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200
opt.virtualedit = "block"
opt.wildmode = "longest:full,full"
opt.winminwidth = 5
opt.wrap = false
