local ensure_installed = {
	"awk",
	"bash",
	"comment",
	"css",
	"diff",
	"git_config",
	"git_rebase",
	"gitattributes",
	"gitcommit",
	"gitignore",
	"graphql",
	"html",
	"http",
	"javascript",
	"jq",
	"json",
	"json5",
	"jsonc",
	"lua",
	"markdown",
	"markdown_inline",
	"passwd",
	"query",
	"regex",
	"scss",
	"sql",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"yaml",
}

local textobjects = {
	select = {
		enable = true,
		lookahead = true,
		lsp_interop = {
			enable = true,
			floating_preview_opts = { border = "rounded" },
			peek_definition_code = { ["<leader>df"] = "@function.outer", ["<leader>dF"] = "@class.outer" },
		},
		keymaps = {
			["aa"] = { query = "@parameter.outer", desc = "around a parameter" },
			["ac"] = { query = "@class.outer", desc = "around a class" },
			["af"] = { query = "@function.outer", desc = "around a function" },
			["ai"] = { query = "@conditional.outer", desc = "around an if statement" },
			["al"] = { query = "@loop.outer", desc = "around a loop" },
			["ao"] = { query = "@block.outer", desc = "around a function block" },
			["ia"] = { query = "@parameter.inner", desc = "inner part of a parameter" },
			["ic"] = { query = "@class.inner", desc = "inner part of a class" },
			["if"] = { query = "@function.inner", desc = "inner part of a function" },
			["il"] = { query = "@loop.inner", desc = "inner part of a loop" },
			["io"] = { query = "@block.inner", desc = "inner part of a function block" },
			["it"] = { query = "@conditional.inner", desc = "inner part of an if statement" },
		},
	},
	move = {
		enable = true,
		set_jumps = true,
		goto_previous_start = {
			["[f"] = { query = "@function.outer", desc = "Previous function" },
			["[c"] = { query = "@class.outer", desc = "Previous class" },
			["[p"] = { query = "@parameter.inner", desc = "Previous parameter" },
		},
		goto_next_start = {
			["]f"] = { query = "@function.outer", desc = "Next function" },
			["]c"] = { query = "@class.outer", desc = "Next class" },
			["]p"] = { query = "@parameter.inner", desc = "Next parameter" },
		},
	},
	swap = {
		enable = true,
		swap_next = { ["<leader>a"] = "@parameter.inner" },
		swap_previous = { ["<leader>A"] = "@parameter.inner" },
	},
}

local M = { "nvim-treesitter/nvim-treesitter" }

M.build = ":TSUpdate"

M.dependencies = {
	"JoosepAlviste/nvim-ts-context-commentstring",
	"nvim-treesitter/nvim-treesitter-textobjects",
	"windwp/nvim-ts-autotag",
	{ "nvim-treesitter/nvim-treesitter-context", opts = { mode = "topline" } },
}

M.event = "BufEnter"

M.opts = {
	auto_install = true,
	autotag = { enable = true },
	context_commentstring = { enable = true, enable_autocmd = true },
	ensure_installed = ensure_installed,
	highlight = { enable = true, additional_vim_regex_highlighting = { "markdown" } },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<space><space>",
			node_decremental = "<bs>",
			node_incremental = "<space><space>",
			scope_incremental = false,
		},
	},
	indent = { enable = true },
	textobjects = textobjects,
}

function M.config(_, opts)
	require("nvim-treesitter.configs").setup(opts)
	require("nvim-treesitter.install").compilers = { "gcc-13" } -- for neorg
end

return M
