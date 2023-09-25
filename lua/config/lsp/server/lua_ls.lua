local config_files = {
	".luarc.json",
	".luarc.jsonc",
	".luacheckrc",
	".stylua.toml",
	"stylua.toml",
	"selene.toml",
	"selene.yml",
}

local settings = {
	Lua = {
		codeLens = {
			enable = true,
		},
		diagnostics = {
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
		unusedLocalExclude = {
			"_*",
		},
		workspace = {
			checkThirdParty = false,
		},
	},
}

local M = {}

M.mason_name = "lua-language-server"

--- @param opts lspconfig.Config
function M.setup(opts)
	require("neodev").setup()

	opts.root_dir = require("config.lsp.util").get_root_pattern(config_files)

	opts.settings = settings

	require("lspconfig").lua_ls.setup(opts)
end

return M
