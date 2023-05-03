local lspconfig = require("lspconfig")
local util = require("config.lsp.util")

local Tsserver = {}

local config_files = { "package.json", "tsconfig.json", "jsconfig.json" }

local javascript_settings = {
	inlayHints = {
		includeInlayParameterNameHints = "all",
		includeInlayParameterNameHintsWhenArgumentMatchesName = false,
		includeInlayFunctionParameterTypeHints = true,
		includeInlayVariableTypeHints = true,
		includeInlayPropertyDeclarationTypeHints = true,
		includeInlayFunctionLikeReturnTypeHints = true,
		includeInlayEnumMemberValueHints = true,
	},
}

local typescript_settings = {
	inlayHints = {
		includeInlayParameterNameHints = "literal",
		includeInlayParameterNameHintsWhenArgumentMatchesName = false,
		includeInlayFunctionParameterTypeHints = false,
		includeInlayVariableTypeHints = false,
		includeInlayPropertyDeclarationTypeHints = false,
		includeInlayFunctionLikeReturnTypeHints = true,
		includeInlayEnumMemberValueHints = true,
	},
}

local settings = {
	javascript = javascript_settings,
	typescript = typescript_settings,
}

function Tsserver.setup(opts)
	opts.root_dir = util.get_root_pattern(config_files)

	lspconfig.vtsls.setup(opts)

	opts.settings = settings

	lspconfig.tsserver.setup(opts)
end

return Tsserver
