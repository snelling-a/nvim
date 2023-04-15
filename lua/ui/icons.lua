local Icons = {}

local copilot = " "
local down = ""
local error = " "
local modified = " "
local right = ""

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

Icons.diagnostics = { Error = error, Hint = " ", Info = " ", Warn = " " }

Icons.git = { added = " ", branch = "󰘬", modified = modified, removed = " " }

Icons.file = { modified = modified, newfile = " ", readonly = " ", unnamed = " " }

Icons.fillchars = { eob = " ", fold = "=", foldclose = right, foldopen = down }

Icons.kind_icons = {
	Class = "ﴯ",
	Color = "",
	Constant = "",
	Constructor = "",
	Copilot = copilot,
	Enum = "",
	EnumMember = "",
	Event = "",
	Field = "",
	File = "",
	Folder = "",
	Function = "",
	Interface = "",
	Keyword = "",
	Method = "",
	Module = "",
	Operator = "",
	Property = "ﰠ",
	Reference = "",
	Snippet = "",
	Struct = "",
	Text = "",
	TypeParameter = "",
	Unit = "",
	Value = "",
	Variable = "",
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
	gears = " ",
	help = "",
	indent = "▏",
	moved = "",
	multi = " ",
	percent = "󰏰 ",
	right = right,
	search = " ",
	selection = " ",
}

Icons.progress = {
	done = " ",
	error = error,
	pending = "󰔟",
	trash = "ﮁ ",
}

return Icons
