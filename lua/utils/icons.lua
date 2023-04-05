local Icons = {}

local error = " "
local modified = " "
local copilot = " "

Icons.diagnostics = { Error = error, Warn = " ", Hint = " ", Info = " " }

Icons.git = { added = " ", branch = "󰘬", modified = modified, removed = " " }

Icons.file = { modified = modified, newfile = " ", readonly = " ", unnamed = " " }

Icons.location = { col = "󰚉 ", line = "󰚈 ", top = " ", bottom = " " }

Icons.misc = {
	code = " ",
	gears = " ",
	percent = "󰏰 ",
	moved = "",
	multi = " ",
	search = " ",
	selection = " ",
	help = "",
}

Icons.progress = {
	done = " ",
	pending = "󰔟",
	error = error,
	trash = "ﮁ ",
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
	sql = "",
	sh = "",
	toml = "",
	typescript = "",
	vim = "",
	yaml = "",
	zsh = "",
}

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

Icons.cmp = {
	Codeium = " ",
	TabNine = " ",
	Copilot = copilot,
	nvim_lsp = " ",
	nvim_lua = " ",
	path = " ",
	buffer = " ",
	spell = "暈 ",
	luasnip = " ",
	treesitter = " ",
}

return Icons
