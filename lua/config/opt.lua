local opt = vim.opt

opt.autowrite = true
opt.clipboard = {
	"unnamed",
	"unnamedplus",
}
opt.confirm = true
opt.diffopt = {
	"internal",
	"filler",
	"closeoff",
	"hiddenoff",
	"algorithm:minimal",
}
opt.expandtab = true
opt.fileencoding = "utf-8"
opt.fileformats = {
	"unix",
	"mac",
}
opt.gdefault = true
opt.grepprg = "rg --hidden --vimgrep --smart-case"
opt.ignorecase = true
opt.isfname:append("@-@")
opt.modelines = 1
opt.mouse = "a"
opt.path:append("**")
opt.runtimepath:append("/usr/local/opt/fzf")
opt.shadafile = "NONE"
opt.shiftround = true
opt.shiftwidth = 4
opt.smartcase = true
opt.smartindent = true
opt.softtabstop = 4
opt.swapfile = false
opt.switchbuf = "split"
opt.tabstop = 4
opt.timeoutlen = 400
opt.ttimeoutlen = 20
opt.undofile = true
opt.updatetime = 200
opt.wildignore:append("*.avi,*.divx,*.mp4,*.webm,*.mov,*.m2ts,*.mkv,*.vob,*.mpg,*.mpeg")
opt.wildignore:append("*.doc,*.pdf,*.cbr,*.cbz")
opt.wildignore:append("*.eot,*.otf,*.ttf,*.woff")
opt.wildignore:append("*.git,.hg,.svn")
opt.wildignore:append("*.mp3,*.oga,*.ogg,*.wav,*.flac")
opt.wildignore:append("*.swp,.lock,.DS_Store,._*")
opt.wildignore:append("*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz,*.kgb")
opt.wildignore:append(".,..")
opt.wildignore:append(".ai,*.bmp,*.gif,*.ico,*.jpg,*.jpeg,*.png,*.psd,*.webp")
opt.wildmode = "list:longest,list:full"
opt.wildoptions = "fuzzy"
opt.writebackup = false
