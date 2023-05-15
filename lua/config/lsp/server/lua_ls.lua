local lspconfig = require("lspconfig")

local config_files =
	{ ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml" }

local settings = {
	Lua = {
		codeLens = { enable = true },
		completion = { keywordSnippet = "Both" },
		diagnostics = {
			enable = true,
			disable = { "spell-check" },
			globals = { "vim" },
			unusedLocalExclude = { "_*" },
		},
		format = { enable = false },
		hint = { enabled = true },
		runtime = { path = vim.split(package.path, ";"), version = "LuaJIT" },
		telemetry = { enable = false },
		workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file("", true) },
	},
}

local M = {}

function M.setup(opts)
	opts.root_dir = lspconfig.util.root_pattern(unpack(config_files))

	opts.settings = settings

	lspconfig.lua_ls.setup(opts)
end

return M
