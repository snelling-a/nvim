local utils = require("utils")

utils.nmap("<leader>n", vim.cmd.NvimTreeToggle, { desc = "NvimTreeToggle" })
utils.nmap("<leader>m", vim.cmd.NvimTreeFindFileToggle, { desc = "NvimTreeFindFileToggle" })

require("nvim-tree").setup({
	view = {
		side = "right",
		number = true,
		relativenumber = true,
		signcolumn = "number",
		mappings = {
			list = {
				{ key = "?", action = "toggle_help" },
			},
		},
	},
	renderer = {
		add_trailing = true,
		highlight_git = true,
		highlight_opened_files = "all",
		highlight_modified = "icon",
		icons = {
			git_placement = "signcolumn",
			modified_placement = "signcolumn",
		},
		special_files = {
			"Cargo.toml",
			"Makefile",
			"README.md",
			"package.json",
			"readme.md",
		},
	},
	diagnostics = {
		enable = true,
	},
	git = {
		ignore = false,
	},
	filters = {
		custom = { "^\\.git$" },
	},
	actions = {
		open_file = {
			quit_on_open = true,
		},
	},
	trash = {
		cmd = "trash",
	},
})
