---@type LazySpec
local M = { "nvim-treesitter/nvim-treesitter" }

---@diagnostic disable-next-line: assign-type-mismatch
M.version = false

M.build = { ":TSUpdate" }

M.dependencies = {
	"nvim-treesitter/nvim-treesitter-textobjects",
	{
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		opts = {},
	},
}

M.event = require("util").constants.lazy_event

---@type TSConfig
---@diagnostic disable-next-line: missing-fields
M.opts = {
	ensure_installed = {
		"awk",
		"bash",
		"comment",
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
		"jsdoc",
		"json",
		"json5",
		"jsonc",
		"lua",
		"luadoc",
		"luap",
		"markdown",
		"markdown_inline",
		"passwd",
		"query",
		"regex",
		"sql",
		"toml",
		"tsx",
		"typescript",
		"vim",
		"vimdoc",
		"xml",
		"yaml",
	},
	highlight = { enable = true },
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "<leader>v",
			node_incremental = "v",
			scope_incremental = false,
			node_decremental = "<bs>",
		},
	},
	indent = { enable = true },
	textobjects = {
		move = {
			enable = true,
			goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
			goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
			goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
			goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
		},
		swap = {
			enable = true,
			swap_next = { ["<leader>a"] = "@parameter.inner" },
			swap_previous = { ["<leader>A"] = "@parameter.inner" },
		},
	},
}

---@param opts TSConfig
function M.config(_, opts)
	if type(opts.ensure_installed) == "table" then
		---@type table<string, boolean>
		local added = {}
		opts.ensure_installed = vim.tbl_filter(function(lang)
			if added[lang] then
				return false
			end

			added[lang] = true

			return true
		end, opts.ensure_installed --[[@as table]])
	end

	require("nvim-treesitter.configs").setup(opts)
end

return M
