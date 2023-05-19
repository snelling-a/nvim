local buffer = " "
local right = ""

local copilot = " "
local down = ""
local elipsis = "…"
local error = "󰅚 "
local file = " "
local folder = " "
local lsp = " "
local modified = "󰏭 "
local moved = "󱦰"
local vert = "┃"
local command_line = " "

local Icons = {}

Icons.dap = {
	Breakpoint = " ",
	BreakpointCondition = " ",
	BreakpointRejected = error,
	LogPoint = ".>",
	Stopped = "",
}

Icons.cmp = {
	Copilot = copilot,
	buffer = buffer,
	luasnip = "󰃐 ",
	nvim_lsp = lsp,
	nvim_lsp_signature_help = lsp,
	nvim_lua = " ",
	path = " ",
	treesitter = " ",
	npm = " ",
	nvim_lsp_document_symbol = lsp,
	cmdline = command_line,
}

Icons.diagnostics = { Error = error, Hint = "󰌶 ", Info = " ", Warn = " " }

Icons.git = {
	added = " ",
	branch = "󰘬",
	commit = " ",
	commit_2 = " ",
	compare = " ",
	folder = " ",
	git = "󰊢 ",
	ignored = " ",
	merge = " ",
	modified = modified,
	removed = " ",
	renamed = moved,
	staged = "󰱒 ",
	stash = "󱞞 ",
	status = " ",
}

Icons.gitsigns = {
	GitSignsAdd = "┃",
	GitSignsChange = "┃",
	GitSignsChangedelete = "┃",
	GitSignsDelete = "╽",
	GitSignsTopdelete = "╿",
	GitSignsUntracked = "┋",
}

Icons.file = {
	buffer = buffer,
	folder_empty = "󰷍 ",
	folder_open = " ",
	import = "󱀯 ",
	modified = modified,
	newfile = file,
	oldfiles = "󱀸 ",
	readonly = " ",
	tab = "󱦞 ",
	unnamed = " ",
}

Icons.fillchars =
	{ diff = "░", eob = " ", fold = "󰇼", foldclose = right, foldopen = down, foldsep = "│", vert = vert }

Icons.kind_icons = {
	Array = "󱡠",
	Boolean = "󰨙",
	Class = " ",
	Color = " ",
	Constant = " ",
	Constructor = " ",
	Copilot = copilot,
	Enum = " ",
	EnumMember = " ",
	Event = " ",
	Field = " ",
	File = file,
	Folder = folder,
	Function = "󰊕 ",
	Interface = " ",
	Keyword = "󰌋 ",
	Method = "󰊕",
	Module = " ",
	Null = "󰟢 ",
	Number = "󰎠",
	Object = "",
	Operator = " ",
	Package = "",
	Property = " ",
	Reference = " ",
	Snippet = " ",
	String = "",
	Struct = " ",
	Text = " ",
	TypeParameter = " ",
	Unit = " ",
	Value = "󰎠 ",
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
	extends = elipsis,
	leadmultispace = " ",
	multispace = "·",
	nbsp = "␣",
	precedes = elipsis,
	tab = "  ",
	trail = "·",
}

Icons.location = { bottom = " ", col = "󰚉 ", line = "󰚈 ", top = " " }

Icons.misc = {
	checklist = " ",
	chevron_down = " ",
	chevron_right = "󰄾 ",
	chevron_up = " ",
	code = " ",
	code_action = "󰘦 ",
	down = down,
	exit = "󰩈 ",
	files = " ",
	gears = " ",
	health = " ",
	help = "󰋖 ",
	indent = "▏",
	keyboard = "󰌓 ",
	l = "ℓ",
	lazy = "󰒲 ",
	lightbulb_alert = "󱧢 ",
	moved = moved,
	multi = " ",
	panda = "󰏚 ",
	percent = "󰏰 ",
	restore = "󰁯 ",
	right = right,
	rocket = " ",
	search = " ",
	search_text = "󰱽 ",
	selection = " ",
	square = "󰝤 ",
	tag = " ",
	tools = " ",
	version = " ",
	wrap = "↵",
}

Icons.progress = { done = "󰗡 ", error = error, pending = "󰔟", trash = " " }

Icons.obsidian = { health = "󱨌 ", new = " ", search = "󱙔 ", today = "󱨰 ", yesterday = "󱓩 " }

return Icons
