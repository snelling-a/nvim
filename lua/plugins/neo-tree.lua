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
			never_show_by_pattern = {
				"*.git",
				"*.hg",
				"*.DS_Store",
				"*.Trashes",
				"*__MACOSX",
				"*ehthumbs.db",
				"*Thumbs.db",
			},
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
				added = icons.gitsigns.GitSignsAdd,
				deleted = icons.gitsigns.GitSignsChangedelete,
				modified = icons.gitsigns.GitSignsAdd,
				renamed = icons.git.renamed,
				untracked = icons.gitsigns.GitSignsUntracked,
				ignored = icons.git.ignored,
				unstaged = "",
				staged = icons.git.staged,
				conflict = icons.git.merge,
			},
		},
	},
	nesting_rules = {
		["ts"] = { "spec.ts", "spec.tsx", "stories.tsx", "stories.mdx" },
		["tsx"] = { "spec.ts", "spec.tsx", "stories.tsx", "stories.mdx" },
		["js"] = { "d.ts" },
		["jsx"] = { "d.ts" },
	},
	source_selector = {
		winbar = true,
		sources = {
			{ source = "filesystem", display_name = icons.misc.files .. " Files " },
			{ source = "buffers", display_name = icons.file.buffer .. " Buffers " },
			{ source = "git_status", display_name = icons.git.git .. " Git " },
		},
	},
}

return M
