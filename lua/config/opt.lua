local opt = vim.opt

opt.autowrite = true
opt.clipboard = {
	"unnamed",
	"unnamedplus",
}
opt.confirm = true
opt.diffopt:append({
	"hiddenoff",
	"vertical",
})
opt.expandtab = true
opt.fileencoding = "utf-8"
opt.fileformats:append("mac")
opt.gdefault = true
opt.grepprg = "rg --hidden --vimgrep --smart-case"
opt.ignorecase = true
opt.isfname:append("@-@")
opt.modelines = 1
opt.mouse = "a"
opt.path:append("**")
opt.runtimepath:append("/usr/local/opt/fzf")
opt.shadafile = "NONE"
opt.shell = "/bin/bash"
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
opt.wildignore:append({
	"*.avi",
	"*.divx",
	"*.m2ts",
	"*.mkv",
	"*.mov",
	"*.mp4",
	"*.mpeg",
	"*.mpg",
	"*.vob",
	"*.webm",
})
opt.wildignore:append({
	"*.cbr",
	"*.cbz",
	"*.doc",
	"*.pdf",
})
opt.wildignore:append({
	"*.eot",
	"*.otf",
	"*.ttf",
	"*.woff",
})
opt.wildignore:append({
	"*.git",
	".hg",
	".svn",
})
opt.wildignore:append({
	"*.flac",
	"*.mp3",
	"*.oga",
	"*.ogg",
	"*.wav",
})
opt.wildignore:append({
	"*.swp",
	".DS_Store",
	"._*",
	".lock",
})
opt.wildignore:append({
	"*.kgb",
	"*.rar",
	"*.tar.bz2",
	"*.tar.gz",
	"*.tar.xz",
	"*.zip",
})
opt.wildignore:append({
	".",
	"..",
})
opt.wildignore:append({
	"*.bmp",
	"*.gif",
	"*.ico",
	"*.jpeg",
	"*.jpg",
	"*.png",
	"*.psd",
	"*.webp",
	".ai",
})
opt.wildmode = "list:longest,list:full"
opt.wildoptions = "fuzzy"
opt.writebackup = false
