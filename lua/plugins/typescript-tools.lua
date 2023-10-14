--- @type LazySpec
local M = {
	"pmizio/typescript-tools.nvim",
}

M.event = require("config.util").tbl_extend_force(require("config.util.constants").lazy_event, {
	"BufNewFile",
	"BufReadPre",
})

M.dependencies = {
	"nvim-lua/plenary.nvim",
	"neovim/nvim-lspconfig",
}

M.ft = require("config.util.constants").javascript_typescript

M.opts = {
	on_attach = require("config.lsp").on_attach,
	settings = {
		expose_as_code_action = "all",
		tsserver_file_preferences = {
			includeCompletionsForImportStatements = true,
			includeCompletionsWithClassMemberSnippets = true,
			includeCompletionsWithObjectLiteralMethodSnippets = true,
			includeCompletionsWithSnippetText = true,
			includeInlayEnumMemberValueHints = true,
			includeInlayFunctionLikeReturnTypeHints = true,
			includeInlayFunctionParameterTypeHints = true,
			includeInlayParameterNameHints = "all",
			includeInlayParameterNameHintsWhenArgumentMatchesName = false,
			includeInlayPropertyDeclarationTypeHints = true,
			includeInlayVariableTypeHints = true,
			includeInlayVariableTypeHintsWhenTypeMatchesName = true,
			providePrefixAndSuffixTextForRename = true,
			provideRefactorNotApplicableReason = true,
			useLabelDetailsInCompletionEntries = true,
		},
		tsserver_format_options = {},
		tsserver_plugins = {
			"@styled/typescript-styled-plugin",
		},
	},
}

return M
