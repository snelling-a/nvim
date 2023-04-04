local opt = require("utils").opt
vim.cmd.colorscheme("base16-default-dark")

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

local shortmess_append = {
	--  f	use "(3 of 5)" instead of "(file 3 of 5)"
	--  i	use "[noeol]" instead of "[Incomplete last line]"
	--  l	use "999L, 888B" instead of "999 lines, 888 bytes"
	--  m	use "[+]" instead of "[Modified]"
	--  n	use "[New]" instead of "[New File]"
	--  r	use "[RO]" instead of "[readonly]"
	--  w	use "[w]" instead of "written" for file write message and "[a]" instead of "appended" for ':w >> file' command
	--  x	use "[dos]" instead of "[dos format]", "[unix]" instead of "[unix format]" and "[mac]" instead of "[mac format]"
	"a", --  all of the above abbreviations
	"c", --  don't give ins-completion-menu messages
	"F", -- don't give the file info when editing a file, like `:silent` was used for the command
	"I", --  don't give the intro message when starting Vim
	"o", -- overwrite message for writing a file with subsequent message for reading a file
	"q", --  use "recording" instead of "recording @a"
	"S", --  do not show search count message when searching, e.g. "[1/5]"
	"s", --  don't give "search hit BOTTOM/TOP, continuing at TOP/BOTTOM" messages; "W" after the count message
	"t", -- truncate file message at the start if it is too long to fit on the command-line
	"W", --	don't give "written" or "[w]" when writing a file
}

local shortmess_remove = {
	"T", -- Truncate other messages in the middle if they are too long to fit on the command line
	"O", -- message for reading a file overwrites any previous message; also for quickfix message (e.g., ":cn")
}

for _, flag in ipairs(shortmess_append) do
	opt.shortmess:append(flag)
end
for _, flag in ipairs(shortmess_remove) do
	opt.shortmess:remove(flag)
end

-- vim.g.netrw_banner = 0
-- vim.g.netrw_browse_split = 2 -- vertically splitting the window first
-- vim.g.netrw_liststyle = 3
-- vim.g.netrw_winsize = 25
