local icons = require("config.ui.icons")
local logger = require("config.util.logger")

local function copy_selector(state)
	local node = state.tree:get_node()
	local filepath = node:get_id()
	local modify = vim.fn.fnamemodify

	local results = {
		{ msg = "Tail of the file name (last component of the name)", val = modify(filepath, ":t") },
		{
			msg = "Reduce file name to be relative to current directory, if possible",
			val = modify(filepath, ":p:."),
		},
		{
			msg = "Reduce file name to be relative to the home directory, if possible",
			val = modify(filepath, ":p:~"),
		},
		{ msg = "Absolute path", val = modify(filepath, ":p") },
		{ msg = "Root of the file name (the last extension removed)", val = modify(filepath, ":t:r") },
		{ msg = "Extension of the file name", val = modify(filepath, ":e") },
	}

	vim.ui.select(vim.tbl_keys(results), {
		prompt = require("config.util").get_prompt(icons.misc.clipboard_check),
		format_item = function(item) return results[item].msg end,
	}, function(choice)
		local val = results[choice].val
		vim.fn.setreg("+", val)
		logger.info({ msg = "Copied to clipboard: " .. val, title = "NeoTree" })
	end)
end

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
	{
		"<leader>gss",
		function() vim.cmd.Neotree({ args = { "float", "git_status" } }) end,
		desc = "Open NeoTree [G]it [S]tatus",
	},
	{ "|", function() vim.cmd.Neotree("reveal") end, desc = "Reveal current file in Neotree" },
}

M.opts = {
	filesystem = {
		commands = { copy_selector = copy_selector },
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
	event_handlers = {
		{ event = "neo_tree_buffer_enter", handler = function(_) vim.opt_local.signcolumn = "auto" end },
	},
	window = {
		position = "right",
		width = 30,
		fuzzy_finder_mappings = { ["<C-j>"] = "move_cursor_down", ["<C-k>"] = "move_cursor_up" },
		mappings = {
			["<C-s>"] = "split_with_window_picker",
			["<C-t>"] = "open_tabnew",
			["<C-v>"] = "vsplit_with_window_picker",
			["<CR>"] = "open_with_window_picker",
			["a"] = { "add", config = { show_path = "relative" } },
			["A"] = { "add_directory", config = { show_path = "relative" } },
			["C"] = "close_all_subnodes",
			["K"] = "toggle_preview",
			["P"] = "noop",
			["V"] = "open_vsplit",
			["W"] = "close_all_nodes",
			["w"] = "open_with_window_picker",
			["y"] = "copy_selector",
			["Z"] = "expand_all_nodes",
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
