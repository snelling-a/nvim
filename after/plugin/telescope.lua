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
utils.nmap("<leader>ff", builtin.find_files, { desc = "[F]ind [f]iles" })
utils.nmap("<leader>fh", builtin.help_tags, { desc = "[H]elp" })
utils.nmap("<leader>qf", builtin.quickfix, { desc = "[Q]uick[f]ix" })

require("telescope").setup {
    defaults = {
        sorting_strategy = "ascending",
        prompt_prefix = " ",
        selection_caret = " ",
        multi_icon = " ",
        mappings = {
            i = {
                ["<M-p>"] = action_layout.toggle_preview,
                ["<C-Down>"] = require('telescope.actions').cycle_history_next,
                ["<C-Up>"] = require('telescope.actions').cycle_history_prev,
            },
            n = {
                ["<M-p>"] = action_layout.toggle_preview,
                ["<C-Down>"] = require('telescope.actions').cycle_history_next,
                ["<C-Up>"] = require('telescope.actions').cycle_history_prev,
            },
        },
        vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--trim" -- add this value
        },
    },
    pickers = {
        lsp_definitions = {
            theme = "cursor",
            initial_mode = "normal",
        },
        lsp_references = {
            theme = "dropdown",
            initial_mode = "normal",
        },
    },
}

	extensions = {
		fzf = {
			case_mode = "smart_case",
			fuzzy = true,
			override_file_sorter = true,
			override_generic_sorter = true,
		},
		["ui-select"] = {
			themes.get_cursor(),
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
