local opt = require("utils").opt

-- vim.g.netrw_banner = 0
-- vim.g.netrw_browse_split = 2 -- vertically splitting the window first
-- vim.g.netrw_liststyle = 3
-- vim.g.netrw_winsize = 25
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

opt.autoindent = true
opt.autowrite = true
opt.backup = false
opt.clipboard = { "unnamed", "unnamedplus" }
opt.cmdheight = 2
opt.colorcolumn = "100"
opt.complete = ".,w,b,u,U"
opt.completeopt = { "menu", "menuone", "noselect" }
opt.confirm = true
opt.expandtab = true
opt.fileformats = { "unix", "mac" }
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldmethod = "expr"
opt.gdefault = true
opt.hlsearch = true
opt.ignorecase = true
opt.incsearch = true
opt.isfname:append("@-@")
opt.laststatus = 2
opt.list = true
opt.listchars:append("tab:  ")
opt.mouse = "a"
opt.number = true
opt.relativenumber = true
opt.scrolloff = 8
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.shiftround = true
opt.shiftwidth = 4
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.smarttab = true
opt.softtabstop = 4
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false
opt.switchbuf = "useopen"
opt.tabstop = 4
opt.termguicolors = true
opt.timeoutlen = 400
opt.title = true
opt.ttimeoutlen = 100
opt.undodir = { os.getenv("HOME") .. "/.vim/undodir" }
opt.undofile = true
opt.updatetime = 50
opt.whichwrap:append({ ["h"] = true, ["l"] = true })
opt.wildmode = "longest,full"
opt.wrap = false
opt.writebackup = false
