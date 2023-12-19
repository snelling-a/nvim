---@type LazySpec
local M = { "catppuccin/nvim" }

-- M.lazy = false

M.name = "catppuccin"

---@type CatppuccinOptions
M.opts = {
	dim_inactive = { enabled = true },
	flavor = "mocha",
	integrations = {
		fidget = false,
		leap = true,
		lsp_trouble = true,
		mason = true,
		mini = { enabled = true },
		native_lsp = {
			enabled = true,
			underlines = {
				errors = { "undercurl" },
				hints = { "undercurl" },
				warnings = { "undercurl" },
				information = { "undercurl" },
			},
			inlay_hints = { background = false },
		},
		semantic_tokens = true,
		symbols_outline = true,
		treesitter_context = true,
		---@diagnostic disable-next-line: assign-type-mismatch
		illuminate = { enabled = true, lsp = true },
	},
}

-- M.priority = 1000

function M.config(_, opts)
	require("catppuccin").setup(opts)
end

return M
