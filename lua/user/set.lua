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
opt.confirm = true
opt.expandtab = true
opt.fileformats = "unix,mac"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldmethod = "expr"
opt.gdefault = true
opt.hlsearch = true
opt.ignorecase = true
opt.incsearch = true
opt.isfname:append("@-@")
opt.laststatus = 2
opt.mouse = "a"
opt.number = true
opt.relativenumber = true
opt.scrolloff = 8
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
opt.wildmode = "longest,full"
opt.wrap = false
opt.writebackup = false

opt.formatoptions = opt.formatoptions
	+ "1" -- Don't break a line after a one-letter word. It's broken before it instead (if possible).
	+ "c" -- Auto-wrap comments using 'textwidth', inserting the current comment leader automatically.
	+ "j" -- Where it makes sense, remove a comment leader when joining lines.
	+ "l" -- Long lines are not broken in insert mode
	+ "n" -- When formatting text, recognize numbered lists.
	+ "q" -- Allow formatting of comments with "gq".
	- "/" -- When 'o' is included: do not insert the comment leader for a // comment after a statement
	- "2" -- When formatting text, use the indent of the second line of a paragraph for the rest of the paragraph
	- "B" -- When joining lines, don't insert a space between two multibyte characters.
	- "M" -- When joining lines, don't insert a space before or after a multibyte character.
	- "]" -- Respect 'textwidth' rigorously.
	- "a" -- Automatic formatting of paragraphs.
	- "b" -- Like 'v', but only auto-wrap if you enter a blank at or before the wrap margin.
	- "m" -- Also break at a multibyte character above 255.
	- "o" -- Auto insert the current comment leader after hitting 'o' or 'O' in Normal mode.
	- "p" -- Don't break lines at single spaces that follow periods.
	- "r" -- Automatically insert the current comment leader after hitting <Enter> in Insert mode.
	- "t" -- Auto-wrap text using 'textwidth'
	- "v" -- Vi-compatible auto-wrapping in insert mode
	- "w" -- Trailing white space indicates a paragraph continues in the next line.
