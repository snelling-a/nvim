
local api = require("nvim-tree.api")
local utils = require("utils")

utils.nmap("<leader>n", vim.cmd.NvimTreeToggle)
utils.nmap("<leader>m", vim.cmd.NvimTreeFindFileToggle)

local function on_attach(bufnr)
    utils.nmap("<C-P>",
        function()
            local node = api.tree.get_node_under_cursor()
            print(node.absolute_path)
        end,
        { buffer = bufnr, noremap = true, silent = true, nowait = true, desc = "print the node's absolute path" })
end

require("nvim-tree").setup {
    on_attach = on_attach,
    view = {
        centralize_selection = true,
        width = 30,
        side = "right",
        number = true,
        relativenumber = true,
        signcolumn = "number",
    },
    git = {
        -- ignore = false
    },
    renderer = {
        add_trailing = true,
        group_empty = false,
        highlight_git = true,
        full_name = false,
        highlight_opened_files = "all",
        highlight_modified = "icon",
        indent_width = 2,
        indent_markers = {
            enable = true,
            inline_arrows = true,
            icons = {
                corner = "└",
                edge = "│",
                item = "│",
                bottom = "─",
                none = " ",
            },
        },
        icons = {
            git_placement = "signcolumn",
            modified_placement = "after",
            padding = " ",
            symlink_arrow = " ➛ ",
            glyphs = {
                default = "",
                symlink = "",
                bookmark = "",
                modified = "●",
                folder = {
                    arrow_closed = "",
                    arrow_open = "",
                    default = "",
                    open = "",
                    empty = "",
                    empty_open = "",
                    symlink = "",
                    symlink_open = "",
                },
                git = {
                    unstaged = "✗",
                    staged = "✓",
                    unmerged = "",
                    renamed = "➜",
                    untracked = "★",
                    deleted = "",
                    ignored = "◌",
                },
            },
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
        show_on_open_dirs = true,
        debounce_delay = 50,
        icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
        },
    },
    filters = {
        dotfiles = false,
        exclude = { "^\\.git$" },
    },
    actions = {
        open_file = {
            quit_on_open = true,
        },
    },
    trash = {
        cmd = "trash",
    },
}
