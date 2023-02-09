local config_util = require("lspconfig.util")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local on_attach = require("lsp_config").on_attach

local inlay_hints = {
	includeInlayEnumMemberValueHints = true,
	includeInlayFunctionLikeReturnTypeHints = true,
	includeInlayFunctionParameterTypeHints = true,
	includeInlayParameterNameHints = "all",
	includeInlayParameterNameHintsWhenArgumentMatchesName = false,
	includeInlayPropertyDeclarationTypeHints = true,
	includeInlayVariableTypeHints = true,
	includeInlayVariableTypeHintsWhenTypeMatchesName = true,
}

require("typescript").setup({
	root_dir = config_util.root_pattern("tsconfig.json", "package.json"),
	server = {
		on_attach = function(client, bufnr)
			capabilities.textDocument.completion.completionItem.snippetSupport = true
			capabilities.textDocument.completion.completionItem.preselectSupport = true
			capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
			capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
			capabilities.textDocument.completion.completionItem.deprecatedSupport = true
			capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
			capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
			capabilities.textDocument.completion.completionItem.resolveSupport =
				{ properties = { "documentation", "detail", "additionalTextEdits" } }
			capabilities.textDocument.codeAction = {
				dynamicRegistration = false,
				codeActionLiteralSupport = {
					codeActionKind = {
						valueSet = {
							"",
							"quickfix",
							"refactor",
							"refactor.extract",
							"refactor.inline",
							"refactor.rewrite",
							"source",
							"source.organizeImports",
						},
					},
				},
			}
			capabilities.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }
			on_attach(client, bufnr)
		end,
	},
	settings = { typescript = { inlayHints = inlay_hints }, javascript = { inlayHints = inlay_hints } },
})
