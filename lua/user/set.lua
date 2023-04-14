local opt = vim.opt

vim.cmd.colorscheme("base16-default-dark")

opt.autoindent = true
opt.autowrite = true
opt.backup = false
opt.clipboard = { "unnamed", "unnamedplus" }
opt.cmdheight = 2
opt.colorcolumn = "100"
opt.complete = ".,w,b,u,u"
opt.completeopt = { "menu", "menuone", "noselect" }
opt.confirm = true
opt.expandtab = true
opt.fileformats = { "unix", "mac" }
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevelstart = 0
opt.foldmethod = "expr"
opt.gdefault = true
opt.grepprg = "rg --vimgrep"
opt.hlsearch = true
opt.ignorecase = true
opt.inccommand = "split"
opt.incsearch = true
opt.isfname:append("@-@")
opt.laststatus = 2
opt.list = true
opt.mouse = "a"
opt.number = true
opt.relativenumber = true
opt.scrollback = 10000
opt.scrolloff = 8
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.shiftround = true
opt.shiftwidth = 4
opt.showmode = false
opt.signcolumn = "yes"
opt.smartcase = true
opt.smartindent = true
opt.smarttab = true
opt.softtabstop = 4
opt.splitbelow = true
opt.splitright = true
opt.swapfile = false
opt.switchbuf = "useopen"
opt.synmaxcol = 500
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
opt.wrap = false
opt.writebackup = false

opt.listchars = {
	extends = "…",
	leadmultispace = " ",
	multispace = "·",
	nbsp = "␣",
	precedes = "…",
	tab = "  ",
	trail = "·",
}

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
