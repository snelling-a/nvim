local opt = vim.opt

opt.autoindent = true
opt.autowrite = true
opt.backup = false
opt.clipboard = { "unnamed", "unnamedplus" }
opt.complete = ".,w,b,u,u"
opt.completeopt = { "menu", "menuone", "noselect" }
opt.confirm = true
opt.expandtab = true
opt.fileformats = { "unix", "mac" }
opt.gdefault = true
opt.grepprg = "rg --hidden --vimgrep --smartcase"
opt.ignorecase = true
opt.isfname:append("@-@")
opt.mouse = "a"
opt.runtimepath:append("/usr/local/opt/fzf")
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.shiftround = true
opt.shiftwidth = 4
opt.smartcase = true
opt.smartindent = true
opt.smarttab = true
opt.softtabstop = 4
opt.swapfile = false
opt.switchbuf = "useopen"
opt.tabstop = 4
opt.timeoutlen = 400
opt.ttimeoutlen = 200
opt.undodir = { os.getenv("HOME") .. "/.vim/undodir" }
opt.undofile = true
opt.updatetime = 200
opt.wildmode = "longest,full"
opt.writebackup = false
