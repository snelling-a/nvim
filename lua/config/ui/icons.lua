local copilot = " "
local down = ""
local error = " "
local file = " "
local folder = " "
local modified = " "
local moved = ""
local vert = "┃"

local Icons = {}

Icons.dap = {
	Breakpoint = " ",
	BreakpointCondition = " ",
	BreakpointRejected = error,
	LogPoint = ".>",
	Stopped = "",
}

Icons.cmp = {
	Codeium = " ",
	Copilot = copilot,
	buffer = " ",
	luasnip = " ",
	nvim_lsp = " ",
	nvim_lua = " ",
	path = " ",
	spell = "暈 ",
	treesitter = " ",
}

Icons.diagnostics = { Error = error, Hint = " ", Info = " ", Warn = " " }

Icons.git = {
	added = " ",
	branch = "󰘬",
	git = " ",
	git_commit = " ",
	git_compare = " ",
	ignored = " ",
	merge = " ",
	modified = modified,
	removed = " ",
	renamed = moved,
	staged = "󰱒 ",
}

Icons.gitsigns = {
	add = { text = vert },
	change = { text = vert },
	changedelete = { text = "󰜥" },
	delete = { text = "_" },
	topdelete = { text = "▔" },
	untracked = { text = "┆" },
}

Icons.file = {
	folder_empty = "󰷍 ",
	folder_open = " ",
	modified = modified,
	newfile = file,
	readonly = " ",
	unnamed = " ",
}

Icons.fillchars =
	{ diff = "░", eob = " ", fold = "󰇼", foldclose = "", foldopen = down, foldsep = "│", vert = vert }

Icons.kind_icons = {
	Copilot = copilot,
	File = file,
	Class = " ",
	Color = " ",
	Constant = " ",
	Constructor = " ",
	Enum = " ",
	EnumMember = " ",
	Event = " ",
	Field = " ",
	Folder = folder,
	Function = "󰊕 ",
	Interface = " ",
	Keyword = "󰌋 ",
	Method = " ",
	Module = " ",
	Operator = " ",
	Property = " ",
	Reference = " ",
	Snippet = " ",
	Struct = " ",
	Text = " ",
	TypeParameter = " ",
	Unit = " ",
	Value = "󰎠 ",
	Null = "󰟢 ",
	Variable = "󰀫 ",
}

Icons.languages = {
	bash = "",
	css = "",
	dockerfile = "",
	go = "",
	html = "",
	javascript = "",
	json = "",
	lua = "",
	markdown = "",
	python = "",
	ruby = "",
	rust = "",
	scss = "",
	sh = "",
	sql = "",
	toml = "",
	typescript = "",
	vim = "",
	yaml = "",
	zsh = "",
}

Icons.listchars = {
	extends = "…",
	leadmultispace = " ",
	multispace = "·",
	nbsp = "␣",
	precedes = "…",
	tab = "  ",
	trail = "·",
}

Icons.location = { bottom = " ", col = "󰚉 ", line = "󰚈 ", top = " " }

Icons.misc = {
	chevron_down = " ",
	chevron_up = " ",
	code = " ",
	down = down,
	exit = "󰩈 ",
	files = " ",
	gears = " ",
	health = " ",
	help = "",
	indent = "▏",
	l = "ℓ",
	lazy = "󰒲 ",
	lightbulb_alert = "󱧢 ",
	moved = moved,
	multi = " ",
	percent = "󰏰 ",
	restore = "󰁯 ",
	right = "",
	search = " ",
	search_text = "󰱽 ",
	selection = " ",
	tools = " ",
	wrap = "↵",
}

Icons.progress = { done = " ", error = error, pending = "󰔟", trash = "ﮁ " }

Icons.obsidian = { health = "󱨌 ", new = " ", search = "󱙔 ", today = "󱨰 ", yesterday = "󱓩 " }

return Icons
