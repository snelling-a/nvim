local opt = require("utils").opt
vim.cmd.colorscheme("base16-default-dark")

-- vim.g.netrw_banner = 0
-- vim.g.netrw_browse_split = 2 -- vertically splitting the window first
-- vim.g.netrw_liststyle = 3
-- vim.g.netrw_winsize = 25
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local options = {
	synmaxcol = 500,
	autoindent = true,
	autowrite = true,
	backup = false,
	clipboard = { "unnamed", "unnamedplus" },
	cmdheight = 2,
	colorcolumn = "100",
	inccommand = "split",
	complete = ".,w,b,u,U",
	completeopt = { "menu", "menuone", "noselect" },
	confirm = true,
	expandtab = true,
	scrollback = 10000,
	showmode = false,
	fileformats = { "unix", "mac" },
	foldexpr = "nvim_treesitter#foldexpr()",
	foldlevelstart = 0,
	foldmethod = "expr",
	gdefault = true,
	hlsearch = true,
	ignorecase = true,
	incsearch = true,
	laststatus = 2,
	list = true,
	mouse = "a",
	number = true,
	relativenumber = true,
	scrolloff = 8,
	sessionoptions = { "buffers", "curdir", "tabpages", "winsize" },
	shiftround = true,
	shiftwidth = 4,
	signcolumn = "yes",
	smartcase = true,
	smartindent = true,
	smarttab = true,
	softtabstop = 4,
	splitbelow = true,
	splitright = true,
	swapfile = false,
	switchbuf = "useopen",
	tabstop = 4,
	termguicolors = true,
	timeoutlen = 400,
	title = true,
	ttimeoutlen = 100,
	undodir = { os.getenv("HOME") .. "/.vim/undodir" },
	undofile = true,
	updatetime = 50,
	wildmode = "longest,full",
	wrap = true,
	writebackup = false,
}

for option, value in pairs(options) do
	opt[option] = value
end

opt.isfname:append("@-@")
opt.listchars:append("tab:  ")
opt.whichwrap:append({ ["h"] = true, ["l"] = true })
