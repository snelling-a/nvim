local TypeScriptTools = { "pmizio/typescript-tools.nvim" }

TypeScriptTools.dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" }

TypeScriptTools.config = true

TypeScriptTools.opts = {
	on_attach = require("config.lsp").on_attach,
	settings = {
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
		tsserver_plugins = { "@styled/typescript-styled-plugin" },
	},
}
return TypeScriptTools
