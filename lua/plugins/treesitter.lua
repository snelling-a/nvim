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
	"xml",
	"yaml",
}

local textobjects = {
	select = {
		enable = true,
		lookahead = true,
		keymaps = {
			["aa"] = "@parameter.outer",
			["ia"] = "@parameter.inner",
			["af"] = "@function.outer",
			["if"] = "@function.inner",
			["ac"] = "@class.outer",
			["ic"] = "@class.inner",
		},
	},
	move = {
		enable = true,
		set_jumps = true,
		goto_next_start = {
			["]f"] = "@function.outer",
			["]]"] = "@class.outer",
		},
		goto_next_end = {
			["]F"] = "@function.outer",
			["]["] = "@class.outer",
		},
		goto_previous_start = {
			["[f"] = "@function.outer",
			["[["] = "@class.outer",
		},
		goto_previous_end = {
			["[F"] = "@function.outer",
			["[]"] = "@class.outer",
		},
	},
	swap = {
		enable = true,
		swap_next = {
			["<leader>a"] = "@parameter.inner",
		},
		swap_previous = {
			["<leader>A"] = "@parameter.inner",
		},
	},
}

--- @type LazySpec
local M = {
	"nvim-treesitter/nvim-treesitter",
}

M.build = ":TSUpdate"

M.dependencies = {
	"JoosepAlviste/nvim-ts-context-commentstring",
	"nvim-treesitter/nvim-treesitter-textobjects",
	"windwp/nvim-ts-autotag",
	{
		"nvim-treesitter/nvim-treesitter-context",
		opts = {
			mode = "topline",
		},
	},
}

M.event = require("config.util.constants").lazy_event

M.opts = {
	auto_install = true,
	autotag = {
		enable = true,
	},
	context_commentstring = {
		enable = true,
		enable_autocmd = true,
	},
	ensure_installed = ensure_installed,
	highlight = {
		enable = true,
		additional_vim_regex_highlighting = {
			"markdown",
			"markdown_inline",
		},
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<space><space>",
			node_decremental = "<bs>",
			node_incremental = "<space><space>",
			scope_incremental = false,
		},
	},
	indent = {
		enable = true,
	},
	textobjects = textobjects,
}

function M.config(_, opts)
	require("nvim-treesitter.configs").setup(opts)
	require("nvim-treesitter.install").compilers = {
		"gcc-13",
	}

	require("config.util").nmap("[x", function() require("treesitter-context").go_to_context() end, {
		silent = true,
		desc = "Jump to conte[x]t",
	})
end

return M
