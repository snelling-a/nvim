--- @type LazySpec
local M = {
	"catppuccin/nvim",
}

M.cmd = {
	"GenerateAverageColor",
}

-- M.lazy = false

M.name = "catppuccin"

M.opts = {
	dim_inactive = {
		enabled = true,
	},
	flavor = "mocha",
	integrations = {
		leap = true,
		markdown = true,
		mason = true,
		mini = true,
		native_lsp = {
			enabled = true,
			underlines = {
				errors = {
					"undercurl",
				},
				hints = {
					"undercurl",
				},
				warnings = {
					"undercurl",
				},
				information = {
					"undercurl",
				},
			},
			inlay_hints = {
				background = false,
			},
		},
		notifier = true,
		notify = true,
		semantic_tokens = true,
		symbols_outline = true,
		treesitter_context = true,
		lsp_trouble = true,
	},
}

-- M.priority = 1000

function M.config(_, opts)
	require("catppuccin").setup(opts)

	-- vim.cmd.colorscheme("catppuccin")
end

return M
