local icons = require("config.ui.icons")

local opt = vim.opt

opt.fillchars = icons.fillchars
opt.foldcolumn = "auto:3"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevelstart = 0
opt.foldmethod = "expr"
opt.hlsearch = true
opt.inccommand = "split"
opt.incsearch = true
opt.list = true
opt.listchars = icons.listchars
opt.numberwidth = 2
opt.scrollback = 10000
opt.scrolloff = 8
opt.showmode = false
opt.signcolumn = "yes:2"
opt.splitbelow = true
opt.splitright = true
opt.synmaxcol = 500
opt.termguicolors = true
opt.whichwrap:append({ ["h"] = true, ["l"] = true })
