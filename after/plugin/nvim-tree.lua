local utils = require("utils")

utils.nmap("<leader>n", vim.cmd.NvimTreeToggle, { desc = "NvimTreeToggle" })
utils.nmap("<leader>m", vim.cmd.NvimTreeFindFileToggle, { desc = "NvimTreeFindFileToggle" })

local renderer = {
	add_trailing = true,
	highlight_git = true,
	highlight_opened_files = "all",
	highlight_modified = "icon",
	icons = { git_placement = "signcolumn", modified_placement = "signcolumn" },
	special_files = {
		"Cargo.toml",
		"Makefile",
		"README.md",
		"package.json",
		"readme.md",
	},
}

local view = {
	side = "right",
	number = true,
	relativenumber = true,
	signcolumn = "number",
	mappings = {
		list = {
			{ key = "?", action = "toggle_help" },
		},
	},
}

require("nvim-tree").setup({
	actions = { open_file = { quit_on_open = true } },
	diagnostics = { enable = true },
	filters = { custom = { "^\\.git$" } },
	git = { ignore = false },
	renderer = renderer,
	trash = { cmd = "trash" },
	view = view,
})
