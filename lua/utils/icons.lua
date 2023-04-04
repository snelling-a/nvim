local Icons = {}

local error = " "
local modified = " "

Icons.diagnostics = { Error = error, Warn = " ", Hint = " ", Info = " " }

Icons.git = { added = " ", branch = "󰘬", modified = modified, removed = " " }

Icons.file = { modified = modified, newfile = " ", readonly = " ", unnamed = " " }

Icons.location = { col = "󰚉 ", line = "󰚈 ", top = " ", bottom = " " }

Icons.misc = {
	copilot = " ",
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

return Icons
