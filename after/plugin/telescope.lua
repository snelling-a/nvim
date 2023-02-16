local action_layout = require("telescope.actions.layout")
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
local previewers = require("telescope.previewers")
local telescope = require("telescope")
local themes = require("telescope.themes")
local utils = require("utils")

local project_files = function()
	local opts = {}
	vim.fn.system("git rev-parse --is-inside-work-tree")
	if vim.v.shell_error == 0 then
		builtin.git_files(opts)
	else
		builtin.find_files(opts)
	end
end

utils.nmap("<C-p>", project_files, { desc = "Open [p]roject files" })
utils.nmap("<C-r>", builtin.live_grep, { desc = "[R]un live grep" })
utils.nmap("<leader><space>", builtin.builtin, { desc = "Open builtins" })
utils.nmap("<leader><tab>", builtin.keymaps, { desc = "Show keymaps" })
utils.nmap("<leader>b", builtin.buffers, { desc = "Show [b]uffers" })
utils.nmap("<leader>bf", builtin.current_buffer_fuzzy_find, { desc = "Current [B]uffer [F]uzzy find" })
utils.nmap("<leader>ff", builtin.find_files, { desc = "[F]ind [f]iles" })
utils.nmap("<leader>fh", builtin.help_tags, { desc = "[H]elp" })
utils.nmap("<leader>qf", builtin.quickfix, { desc = "[Q]uick[f]ix" })
utils.nmap('""', builtin.registers, { desc = "View registers" })

local base_mappings = {
	["<C-Down>"] = actions.cycle_history_next,
	["<C-Up>"] = actions.cycle_history_prev,
	["<C-c>"] = actions.close,
	["<M-p>"] = action_layout.toggle_preview,
}

local n_mappings = {
	["q"] = actions.close,
}

local mappings = {
	i = base_mappings,
	n = utils.tbl_extend_force(base_mappings, n_mappings),
}

local hide_on_startup = { preview = { hide_on_startup = true } }
local mode_insert = { initial_mode = "insert" }
local mode_normal = { initial_mode = "normal" }

local cursor_insert = themes.get_cursor(mode_insert)
local cursor_normal = themes.get_cursor(mode_normal)
local dropdown_insert = themes.get_dropdown(mode_insert)
local dropdown_normal = themes.get_dropdown(mode_normal)
local ivy_insert = themes.get_ivy(mode_insert)
local ivy_normal = themes.get_ivy(mode_normal)

local pickers = {
	builtin = utils.tbl_extend_force(dropdown_insert, hide_on_startup),
	find_files = { find_command = { "fd", "--type", "f", "--hidden" } },

	git_bcommits = mode_normal,
	git_branches = mode_normal,
	git_commits = mode_normal,
	git_status = mode_normal,
	keymaps = dropdown_insert, -- cSpell:enableCompoundWords
	live_grep = utils.tbl_extend_force(ivy_insert, { glob_pattern = "!*node_modules" }),
	lsp_definitions = cursor_normal,
	lsp_document_symbols = ivy_normal,
	lsp_implementations = ivy_normal,
	lsp_references = dropdown_normal,
	lsp_type_definitions = cursor_normal,
	lsp_workspace_symbols = ivy_normal,
	registers = dropdown_normal,
}

telescope.setup({
	defaults = {
		mappings = mappings,
		multi_icon = " ",
		layout_strategy = "flex",
		prompt_prefix = " ",
		selection_caret = " ",
		sorting_strategy = "ascending",
		vimgrep_arguments = { "rg", "--vimgrep", "--smart-case", "--trim", "--hidden" },
		file_previewer = previewers.cat.new,
		grep_previewer = previewers.vimgrep.new,
		qflist_previewer = previewers.qflist.new,
	},
	file_ignore_patterns = { ".git/$", "*/**/node_modules/*" },
	pickers = pickers,
	extensions = {
		fzf = { case_mode = "smart_case", fuzzy = true, override_file_sorter = true, override_generic_sorter = true },
		["ui-select"] = {
			cursor_insert,
			specific_opts = { code_actions = dropdown_normal },
		},
	},
})

vim.api.nvim_create_user_command(
	"NodeModules",
	function() vim.cmd.Telescope("node_modules", "list") end,
	{ desc = "Explore node_modules" }
)

telescope.load_extension("fzf")
telescope.load_extension("node_modules")
telescope.load_extension("noice")
telescope.load_extension("octo")
telescope.load_extension("ui-select")
