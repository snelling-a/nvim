local action_layout = require("telescope.actions.layout")
local builtin = require('telescope.builtin')
local utils = require("utils")

local project_files = function()
    local opts = {} -- define here if you want to define something
    vim.fn.system('git rev-parse --is-inside-work-tree')
    if vim.v.shell_error == 0 then
        builtin.git_files(opts)
    else
        builtin.find_files(opts)
    end
end

utils.nmap('<C-b>', builtin.buffers)
utils.nmap('<C-p>', project_files)
utils.nmap('<C-r>', builtin.live_grep)
utils.nmap('<leader><space>', builtin.builtin)
utils.nmap('<leader><tab>', builtin.keymaps)
utils.nmap('<leader>fb', builtin.buffers)
utils.nmap('<leader>ff', builtin.find_files)
utils.nmap('<leader>fh', builtin.help_tags)
utils.nmap('<leader>qf', builtin.quickfix)

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
    extensions = {
        fzf = {
            fuzzy = true, -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true, -- override the file sorter
            case_mode = "smart_case", -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        }
    }
}

require('telescope').load_extension('fzf')
-- require('telescope').load_extension('octo')
require('telescope').load_extension('node_modules')

