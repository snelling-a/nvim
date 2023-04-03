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
}

Icons.progress = {
	done = " ",
	pending = "󰔟",
	error = Icons.diagnostics.Error,
	trash = "ﮁ ",
}

Icons.packer = {
	working_sym = "",
	error_sym = "",
	done_sym = "",
	removed_sym = "ﮁ",
	moved_sym = "",
	header_sym = "—",
}

return Icons
