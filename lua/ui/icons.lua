local buffer = " "
local checklist = " "
local chevron_right = "󰄾 "
local code = " "
local command_line = " "
local copilot = " "
local curly_brackets = " "
local done = "󰗡 "
local down = ""
local elipsis = "…"
local error = "󰅚 "
local event = " "
local file = " "
local folder_open = " "
local func = "󰊕 "
local gear = " "
local gears = " "
local import = "󱀯 "
local key = " "
local keyboard = "󰌓 "
local line = "󰚈 "
local log = "󰦪 "
local lsp = " "
local lua = " "
local modified = "󰏭 "
local number = "󰎠 "
local package = " "
local pending = "󰔟"
local repeat_arrows = "󰑖 "
local right = ""
local rocket = " "
local selection = " "
local snippet = "󰩫 "
local trail = "·"
local typescript = "󰛦 "
local variable = "󰀫 "

---@class ui.icons
local M = {}

M.dap = {
	Breakpoint = " ",
	BreakpointCondition = " ",
	BreakpointRejected = error,
	LogPoint = ".>",
	Stopped = "󰁕 ",
}

M.diagnostics = {
	Error = error,
	Hint = "󰌶 ",
	Info = "󰋽 ",
	Warn = "󰀪 ",
}

M.file = {
	folder_open = folder_open,
	modified = modified,
	unnamed = " ",
}

M.fillchars = {
	diff = "░",
	eob = " ",
	fold = " ",
	foldclose = right,
	foldopen = down,
	foldsep = "║",
	vert = "│",
}

M.git = {
	added = " ",
	compare = " ",
	diff = " ",
	git = "󰊢 ",
	github = " ",
	modified = modified,
	pull = " ",
	removed = " ",
}

M.gitsigns = {
	add = { text = "┃" },
	change = { text = "┃" },
	changedelete = { text = "┃" },
	delete = { text = "╽" },
	topdelete = { text = "╿" },
	untracked = { text = "┋" },
}

M.kind_icons = {
	Array = "󱡠 ",
	Boolean = "󰨙 ",
	BreakStatement = "󰙧 ",
	Call = "󰃷 ",
	CaseStatement = "󱃙 ",
	Class = " ",
	Color = " ",
	Constant = " ",
	Constructor = gear,
	ContinueStatement = "→ ",
	Copilot = copilot,
	Declaration = "󰙠 ",
	Delete = "󰩺 ",
	DoStatement = repeat_arrows,
	Enum = " ",
	EnumMember = " ",
	Event = event,
	Field = " ",
	File = file,
	Folder = " ",
	ForStatement = repeat_arrows,
	Function = func,
	Identifier = variable,
	IfStatement = "󰇉 ",
	Interface = " ",
	Key = key,
	Keyword = key,
	List = line,
	Log = log,
	Lsp = lsp,
	Macro = "󰁌 ",
	MarkdownH1 = "󰉫 ",
	MarkdownH2 = "󰉬 ",
	MarkdownH3 = "󰉭 ",
	MarkdownH4 = "󰉮 ",
	MarkdownH5 = "󰉯 ",
	MarkdownH6 = "󰉰 ",
	Method = func,
	Module = package,
	Namespace = curly_brackets,
	Null = "󰟢 ",
	Number = number,
	Object = curly_brackets,
	Operator = " ",
	Package = package,
	Property = " ",
	Reference = " ",
	Regex = " ",
	Repeat = repeat_arrows,
	Scope = curly_brackets,
	Snippet = snippet,
	Specifier = log,
	Statement = curly_brackets,
	String = "󱆨 ",
	Struct = " ",
	SwitchStatement = "󰺟 ",
	Text = " ",
	Type = " ",
	TypeParameter = " ",
	Unit = " ",
	Value = number,
	Variable = variable,
	WhileStatement = repeat_arrows,
}

M.lazy = {
	cmd = command_line,
	config = gears,
	event = event,
	ft = buffer,
	import = import,
	init = rocket,
	keys = keyboard,
	list = { selection, chevron_right, "‒", trail },
	loaded = done,
	not_loaded = pending,
	plugin = package,
	runtime = code,
	source = folder_open,
	start = right,
	task = checklist,
}

M.listchars = {
	extends = elipsis,
	multispace = "·",
	leadmultispace = " ",
	nbsp = "␣",
	precedes = elipsis,
	tab = "  ",
	trail = trail,
}

M.misc = {
	jira = "󰌃 ",
	l = "ℓ",
	leadmultispace = "▏",
	outline = " ",
	right = right,
	rocket = rocket,
	search = " ",
	square = "󰝤 ",
	thread = " ",
	tilde = "󰜥 ",
	undo = " ",
	version = " ",
	wrap = "󰴐 ",
}

M.progress = {
	done = done,
	error = error,
	pending = pending,
	trash = " ",
}

M.servers = {
	bashls = "󱆃 ",
	copilot = copilot,
	cssls = " ",
	denols = "톋",
	eslint = " ",
	go = " ",
	graphql = " ",
	html = " ",
	javascript = "",
	jsonls = " ",
	lua_ls = lua,
	marksman = " ",
	python = " ",
	ruby = " ",
	rust = " ",
	scss = " ",
	sqlls = " ",
	taplo = gear,
	tsserver = typescript,
	["typescript-tools"] = typescript,
	vimls = " ",
	yamlls = gear,
	zsh = " ",
}

return M
