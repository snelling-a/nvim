local Keymap = require("keymap").nmap

---@type LazySpec
local M = { "neovim/nvim-lspconfig" }

M.opts = function(_, opts)
	local inlay_hints = {
		includeInlayEnumMemberValueHints = true,
		includeInlayFunctionLikeReturnTypeHints = true,
		includeInlayFunctionParameterTypeHints = true,
		includeInlayParameterNameHints = "all",
		includeInlayParameterNameHintsWhenArgumentMatchesName = false, -- false
		includeInlayPropertyDeclarationTypeHints = true,
		includeInlayVariableTypeHints = true,
		includeInlayVariableTypeHintsWhenTypeMatchesName = true, -- false
	}

	Keymap("<leader>cR", function()
		vim.lsp.buf.code_action({
			apply = true,
			context = {
				only = { "source.removeUnused.ts" },
				diagnostics = {},
			},
		})
	end, { desc = "Remove Unused Imports" })
	Keymap("<leader>co", function()
		vim.lsp.buf.code_action({
			apply = true,
			context = {
				only = { "source.organizeImports.ts" },
				diagnostics = {},
			},
		})
	end, { desc = "Organize Imports" })

	return vim.tbl_deep_extend("force", opts, {
		servers = {
			tsserver = {
				settings = {
					typescript = {
						inlayHints = inlay_hints,
					},
					javascript = {
						inlayHints = inlay_hints,
					},
					completions = {
						completeFunctionCalls = true,
					},
				},
			},
		},
	})
end

local filetypes = require("util.constants").javascript_typescript
local formatters = { "eslint_d", "prettierd" }

local language_setup = require("lsp.util").setup_language({
	langs = filetypes,
	formatters = formatters,
	linters = { "eslint_d" },
	ts = { "typescript", "tsx", "javascript" },
})

return {
	M,
	{
		"mfussenegger/nvim-lint",
		opts = function(_, opts)
			for _, v in pairs(filetypes) do
				opts.linters_by_ft = vim.tbl_deep_extend("force", opts.linters_by_ft or {}, {
					[v] = { "snyk_iac" },
				})
			end
		end,
	},
	unpack(language_setup),
}
