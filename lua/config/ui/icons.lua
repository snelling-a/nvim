local buffer = " "
local checklist = " "
local chevron_right = "󰄾 "
local code = " "
local command_line = " "
local copilot = " "
local done = "󰗡 "
local down = ""
local elipsis = "…"
local error = "󰅚 "
local event = " "
local file = " "
local folder = " "
local folder_open = " "
local gears = " "
local import = "󱀯 "
local key = " "
local keyboard = "󰌓 "
local line = "󰚈 "
local lsp = " "
local modified = "󰏭 "
local moved = "󱦰"
local package = ""
local pending = "󰔟"
local right = ""
local rocket = " "
local selection = " "
local snippet = "󰩫 "
local trail = "·"
local variable = "󰀫 "
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
	Copilot = copilot,
	buffer = buffer,
	luasnip = snippet,
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

Icons.headings = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " }

Icons.file = {
	buffer = buffer,
	folder_empty = "󰷍 ",
	folder_open = folder_open,
	import = import,
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
	Array = "󱡠 ",
	Boolean = "󰨙 ",
	BreakStatement = "󰙧 ",
	Call = "󰃷 ",
	CaseStatement = "󱃙 ",
	Class = " ",
	Color = " ",
	Constant = " ",
	Constructor = " ",
	ContinueStatement = "→ ",
	Copilot = copilot,
	Declaration = "󰙠 ",
	Delete = "󰩺 ",
	DoStatement = "󰑖 ",
	Enum = " ",
	EnumMember = " ",
	Event = event,
	Field = " ",
	File = file,
	Folder = folder,
	ForStatement = "󰑖 ",
	Function = "󰊕 ",
	Identifier = variable,
	IfStatement = "󰇉 ",
	Interface = " ",
	Keyword = key,
	Key = key,
	List = line,
	Log = "󰦪 ",
	Lsp = " ",
	Macro = "󰁌 ",
	MarkdownH1 = "󰉫 ",
	MarkdownH2 = "󰉬 ",
	MarkdownH3 = "󰉭 ",
	MarkdownH4 = "󰉮 ",
	MarkdownH5 = "󰉯 ",
	MarkdownH6 = "󰉰 ",
	Method = "󰊕",
	Module = " ",
	Namespace = " ",
	Null = "󰟢 ",
	Number = "󰎠",
	Object = "",
	Operator = " ",
	Package = package,
	Property = " ",
	Reference = " ",
	Regex = " ",
	Repeat = "󰑖 ",
	Scope = " ",
	Snippet = snippet,
	Specifier = "󰦪 ",
	Statement = " ",
	String = "󱆨 ",
	Struct = " ",
	SwitchStatement = "󰺟 ",
	Text = " ",
	Type = " ",
	TypeParameter = " ",
	Unit = " ",
	Value = "󰎠 ",
	Variable = variable,
	WhileStatement = "󰑖 ",
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

Icons.lazy = {
	cmd = command_line,
	config = gears,
	event = event,
	ft = buffer,
	init = rocket,
	import = import,
	keys = keyboard,
	loaded = done,
	not_loaded = pending,
	plugin = package,
	runtime = code,
	source = folder_open,
	start = right,
	task = checklist,
	list = { selection, chevron_right, "‒", trail },
}

Icons.listchars = {
	extends = elipsis,
	leadmultispace = " ",
	multispace = "·",
	nbsp = "␣",
	precedes = elipsis,
	tab = "  ",
	trail = trail,
}

Icons.location = { bottom = " ", col = "󰚉 ", line = line, top = " " }

Icons.misc = {
	checklist = checklist,
	chevron_down = " ",
	chevron_right = chevron_right,
	chevron_up = " ",
	clipboard_check = "󰢨 ",
	code = code,
	code_action = "󰘦 ",
	down = down,
	exit = "󰩈 ",
	files = " ",
	gears = gears,
	health = " ",
	help = "󰋖 ",
	indent = "▏",
	keyboard = keyboard,
	l = "ℓ",
	lazy = "󰒲 ",
	lightbulb_alert = "󱧢 ",
	moved = moved,
	multi = " ",
	note = " ",
	panda = "󰏚 ",
	percent = "󰏰 ",
	restore = "󰁯 ",
	right = right,
	rocket = rocket,
	search = " ",
	search_text = "󰱽 ",
	selection = selection,
	square = "󰝤 ",
	tag = " ",
	tools = " ",
	version = " ",
	wrap = "↵",
}

Icons.progress = { done = done, error = error, pending = pending, trash = " " }

Icons.obsidian = { health = "󱨌 ", new = " ", search = "󱙔 ", today = "󱨰 ", yesterday = "󱓩 " }

return Icons
