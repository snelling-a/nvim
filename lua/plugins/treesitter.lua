local util = require("config.util")

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
			["af"] = "@function.outer",
			["if"] = "@function.inner",
			["aa"] = "@parameter.outer",
			["ia"] = "@parameter.inner",
			["ac"] = "@call.outer",
			["ic"] = "@call.inner",
			["ao"] = "@block.outer",
			["io"] = "@block.inner",
		},
	},
}

local M = { "nvim-treesitter/nvim-treesitter" }

M.build = ":TSUpdate"

M.dependencies = {
	"HiPhish/nvim-ts-rainbow2",
	"JoosepAlviste/nvim-ts-context-commentstring",
	"nvim-treesitter/nvim-treesitter-textobjects",
	"windwp/nvim-ts-autotag",
	{ "nvim-treesitter/nvim-treesitter-context", opts = { mode = "topline" }, config = true },
}

M.event = { "BufReadPost", "BufNewFile" }

M.opts = {
	auto_install = true,
	autotag = { enable = true },
	context_commentstring = { enable = true, enable_autocmd = true },
	ensure_installed = ensure_installed,
	highlight = { enable = true },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = false,
			node_incremental = "grn",
			scope_incremental = "grc",
			node_decremental = "grm",
		},
	},
	indent = { enable = true },
	textobjects = textobjects,
}

M.version = false

function M.config(_, opts)
	require("nvim-treesitter.configs").setup(util.tbl_extend_force(opts, {
		rainbow = {
			enable = true,
			extended_mode = true,
			query = "rainbow-parens",
			strategy = require("ts-rainbow").strategy.global,
		},
	}))
end

return M