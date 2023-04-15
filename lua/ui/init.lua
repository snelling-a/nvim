require("ui.shortmess")

local icons = require("ui.icons")

local opt = vim.opt

vim.cmd.colorscheme("base16-default-dark")

opt.colorcolumn = "100"
opt.fillchars = icons.fillchars
opt.foldcolumn = "auto"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevelstart = 0
opt.foldmethod = "expr"
opt.hlsearch = true
opt.inccommand = "split"
opt.incsearch = true
opt.list = true
opt.listchars = icons.listchars
opt.number = true
opt.relativenumber = true
opt.scrollback = 10000
opt.scrolloff = 8
opt.showmode = false
opt.signcolumn = "auto"
opt.splitbelow = true
opt.splitright = true
opt.synmaxcol = 500
opt.termguicolors = true
opt.whichwrap:append({ ["h"] = true, ["l"] = true })
opt.wrap = false
