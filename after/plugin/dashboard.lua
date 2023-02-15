local status_ok, dashboard = pcall(require, "dashboard")
if not status_ok or vim.g.started_by_firenvim then
	return
end

local custom_header = {
	" ███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
	" ████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
	" ██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
	" ██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
	" ██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
	" ╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
	"",
}

dashboard.setup({
	theme = "hyper",
	packages = { enable = true },
	config = {
		header = custom_header,
		footer = {},
		shortcut = {
			{ desc = "  New file ", action = "enew", group = "@string", key = "n" },
			{ desc = "   Update ", action = "PackerSync", group = "@string", key = "u" },
			{ desc = "   File/path ", action = "Telescope find_files", group = "@string", key = "f" },
			{ desc = "   Quit ", action = "q!", group = "@macro", key = "q" },
		},
	},
})
