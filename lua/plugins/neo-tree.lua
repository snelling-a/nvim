local icons = require("config.ui.icons")

local M = { "nvim-neo-tree/neo-tree.nvim" }

M.dependencies = {
	"MunifTanjim/nui.nvim",
	"nvim-lua/plenary.nvim",
	"nvim-tree/nvim-web-devicons",
	{
		"s1n7ax/nvim-window-picker",
		opts = {
			autoselect_one = true,
			filter_rules = {
				bo = { buftype = { "terminal", "quickfix" }, filetype = { "neo-tree", "neo-tree-popup", "notify" } },
			},
			include_current = false,
			other_win_hl_color = "#e35e4f",
		},
	},
}

M.keys = {
	{ "<leader>.", function() vim.cmd.Neotree("toggle") end, desc = "Toggle NeoTree" },
	{ "<leader>bf", function() vim.cmd.Neotree("buffers") end, desc = "Toggle open buffers" },
	{ "<leader>gss", function() vim.cmd.Neotree({ args = { "float", "git_status" } }) end },
	{ "|", function() vim.cmd.Neotree("reveal") end, desc = "Reveal current file in Neotree" },
}

M.opts = {
	filesystem = {
		filtered_items = {
			never_show = { ".git", ".hg", ".DS_Store", ".Trashes", "__MACOSX", "ehthumbs.db", "Thumbs.db" },
			hide_dotfiles = false,
			hide_gitignored = false,
			visible = true,
		},
	},
	window = {
		position = "right",
		width = 30,
		fuzzy_finder_mappings = { ["<C-j>"] = "move_cursor_down", ["<C-k>"] = "move_cursor_up" },
		mappings = {
			["<cr>"] = "open_with_window_picker",
			["l"] = "focus_preview",
			["S"] = "split_with_window_picker",
			["s"] = "vsplit_with_window_picker",
			["t"] = "open_tabnew",
			["w"] = "open_with_window_picker",
			["C"] = "close_all_subnodes",
			["z"] = "close_all_nodes",
			["Z"] = "expand_all_nodes",
			["a"] = { "add", config = { show_path = "relative" } },
			["A"] = { "add_directory", config = { show_path = "relative" } },
		},
	},
	open_files_do_not_replace_types = { "terminal", "trouble", "qf", "neo-tree" },
	default_component_configs = {
		icon = {
			folder_closed = icons.kind_icons.Folder,
			folder_open = icons.file.folder_open,
			folder_empty = icons.file.folder_empty,
		},
		git_status = {
			symbols = {
				added = icons.git.added,
				conflict = icons.git.merge,
				deleted = icons.git.removed,
				ignored = icons.git.ignored,
				-- modified = icons.git.modified,
				renamed = icons.git.renamed,
				staged = icons.git.staged,
				unstaged = icons.git.modified,
				untracked = icons.misc.help,
			},
		},
	},
}

M.config = true

return M
