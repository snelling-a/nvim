local Icons = {}

local modified = " "

Icons.diagnostics = { Error = " ", Warn = " ", Hint = " ", Info = " " }

Icons.git = { added = " ", branch = "󰘬", modified = modified, removed = " " }

Icons.file = { modified = modified, newfile = " ", readonly = " ", unnamed = " " }

Icons.location = { col = "󰚉 ", line = "󰚈 ", top = " ", bottom = " " }

Icons.misc = {
	copilot = " ",
	gears = " ",
	lock = " ",
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
	error = Icons.diagnostics.Error,
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
