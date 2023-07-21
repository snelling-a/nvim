local opt = vim.opt

opt.autoindent = true
opt.autowrite = true
opt.background = "dark"
opt.backup = false
opt.clipboard = { "unnamed", "unnamedplus" }
opt.cmdheight = 1
opt.complete = ".,w,b,u,u"
opt.completeopt = { "menu", "menuone", "noselect" }
opt.conceallevel = 0
opt.confirm = true
opt.expandtab = true
opt.fileencoding = "utf-8"
opt.fileformats = { "unix", "mac" }
opt.gdefault = true
opt.grepprg = "rg --hidden --vimgrep --smartcase"
opt.guifont = "Iosevka Nerd Font Mono"
opt.hlsearch = true
opt.ignorecase = true
opt.isfname:append("@-@")
opt.mouse = "a"
opt.path:append("**")
opt.pumheight = 10
opt.runtimepath:append("/usr/local/opt/fzf")
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.shiftround = true
opt.shiftwidth = 4
opt.showmode = false
opt.smartcase = true
opt.smartindent = true
opt.smarttab = true
opt.softtabstop = 4
opt.swapfile = false
opt.switchbuf = "useopen"
opt.tabstop = 4
opt.termguicolors = true
opt.timeoutlen = 400
opt.ttimeoutlen = 20
opt.undodir = { os.getenv("HOME") .. "/.vim/undodir" }
opt.undofile = true
opt.updatetime = 200
opt.wildignore:append(".,..")
opt.wildignore:append(".ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp")
opt.wildignore:append("*.avi,*.divx,*.mp4,*.webm,*.mov,*.m2ts,*.mkv,*.vob,*.mpg,*.mpeg")
opt.wildignore:append("*.doc,*.pdf,*.cbr,*.cbz")
opt.wildignore:append("*.eot,*.otf,*.ttf,*.woff")
opt.wildignore:append("*.git,.hg,.svn")
opt.wildignore:append("*.mp3,*.oga,*.ogg,*.wav,*.flac")
opt.wildignore:append("*.swp,.lock,.DS_Store,._*")
opt.wildignore:append("*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz,*.kgb")
opt.wildmode = "list:longest,list:full"
opt.writebackup = false
