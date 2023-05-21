local lspconfig = require("lspconfig")

local config_files =
	{ ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml" }

local settings = {
	Lua = {
		codeLens = { enable = true },
		diagnostics = { globals = { "vim" } },
		format = { enable = false },
		hint = {
			enable = true,
			arrayIndex = "Disable",
			await = true,
			paramName = "Disable",
			semicolon = "Disable",
			setType = true,
		},
		unusedLocalExclude = { "_*" },
		workspace = { checkThirdParty = false },
	},
}

local M = {}

function M.setup(opts)
	require("neodev").setup()

	opts.root_dir = lspconfig.util.root_pattern(unpack(config_files))

	opts.settings = settings

	lspconfig.lua_ls.setup(opts)
end

return M
