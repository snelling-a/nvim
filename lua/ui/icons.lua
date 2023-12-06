local buffer = " "
local checklist = " "
local chevron_right = "󰄾 "
local code = " "
local command_line = " "
local copilot = " "
local done = "󰗡 "
local down = ""
local elipsis = "…"
local error = "󰅚 "
local event = " "
local file = " "
local folder_open = " "
local gear = " "
local gears = " "
local import = "󱀯 "
local key = " "
local keyboard = "󰌓 "
local line = "󰚈 "
local lsp = " "
local lua = " "
local modified = "󰏭 "
local package = " "
local pending = "󰔟"
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

M.cmp = {
	Copilot = copilot,
	buffer = buffer,
	cmdline = command_line,
	luasnip = snippet,
	npm = " ",
	nvim_lsp = lsp,
	nvim_lsp_document_symbol = lsp,
	nvim_lsp_signature_help = lsp,
	nvim_lua = lua,
	path = " ",
	treesitter = " ",
}

M.diagnostics = {
	Error = error,
	Hint = "󰌶 ",
	Info = " ",
	Warn = " ",
}

M.file = {
	buffer = buffer,
	folder_empty = "󰷍 ",
	folder_open = folder_open,
	import = import,
	modified = modified,
	newfile = file,
	oldfiles = "󱀸 ",
	readonly = " ",
	tab = "󱦞 ",
	unnamed = " ",
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

M.fillchars = {
	diff = "░",
	eob = " ",
	fold = "━",
	foldclose = right,
	foldopen = down,
	foldsep = "║",
	vert = " ",
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
	Folder = " ",
	ForStatement = "󰑖 ",
	Function = "󰊕 ",
	Identifier = variable,
	IfStatement = "󰇉 ",
	Interface = " ",
	Key = key,
	Keyword = key,
	List = line,
	Log = "󰦪 ",
	Lsp = lsp,
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

M.lazy = {
	cmd = command_line,
	config = gears,
	event = event,
	ft = buffer,
	import = import,
	init = rocket,
	keys = keyboard,
	list = {
		selection,
		chevron_right,
		"‒",
		trail,
	},
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

M.location = {
	bottom = " ",
	top = " ",
}

M.misc = {
	fold_start = "┣",
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
