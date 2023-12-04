---@type LazySpec
local M = { "neovim/nvim-lspconfig" }

M.opts = {
	servers = {
		lua_ls = {
			settings = {
				Lua = {
					workspace = {
						checkThirdParty = "Disable",
					},
					completion = {
						callSnippet = "Replace",
					},
					codeLens = {
						enable = true,
					},
					diagnostics = {
						unusedLocalExclude = {
							"_*",
						},
						globals = {
							"vim",
						},
					},
					format = {
						enable = false,
					},
					hint = {
						arrayIndex = "Disable",
						await = true,
						enable = true,
						paramName = "Literal",
						paramType = true,
						semicolon = "Disable",
						setType = true,
					},
				},
			},
		},
	},
}

local language_setup = require("lsp.util").setup_language({
	langs = { "lua" },
	linters = { "luacheck" },
	formatters = { "stylua" },
})

return {
	M,
	unpack(language_setup),
}
