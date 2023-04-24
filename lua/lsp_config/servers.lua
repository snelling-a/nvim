local lsp_ok, config_util = pcall(require, "lspconfig.util")
local api = vim.api

if not lsp_ok then
	return
end

local Servers = {}

Servers.awk_ls = {}

Servers.bashls = {}

--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
Servers.cssls = { capabilities = capabilities }

Servers.denols = { root_dir = config_util.root_pattern("deno.json", "deno.jsonc") }

Servers.emmet_ls = {}

Servers.eslint = {
	root_dir = config_util.root_pattern(
		".eslintrc",
		".eslintrc.cjs",
		".eslintrc.js",
		".eslintrc.json",
		".eslintrc.yaml",
		".eslintrc.yml"
	),
}

Servers.graphql = { root_dir = config_util.root_pattern(".graphqlrc*", ".graphql.config.*", "graphql.config.*") }

Servers.jsonls =
	{ settings = { json = { schemas = require("schemastore").json.schemas(), validate = { enable = true } } } }

Servers.lua_ls = {
	root_dir = config_util.root_pattern(".luarc.json", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml"),
	settings = {
		Lua = {
			completion = { keywordSnippet = "Both" },
			diagnostics = { globals = { "vim" } },
			format = { enable = false },
			hint = { enabled = true },
			runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
			telemetry = { enable = false },
			workspace = { library = api.nvim_get_runtime_file("", true), checkThirdParty = false },
		},
	},
}

Servers.sqlls = {}

Servers.taplo = {
	root_dir = config_util.root_pattern(".taplo.toml"),
	settings = { evenBetterToml = { schema = { repositoryEnabled = true } } },
}

Servers.vimls = { vimls = { indexes = { "runtime", "nvim", "autoload", "plugin" } } }

Servers.yamlls = {
	root_dir = config_util.root_pattern(".yamlfmt", ".yamllint"),
	settings = {
		yaml = {
			validate = true,
			hover = true,
			completion = true,
			schemaStore = { enable = true, url = "https://www.schemastore.org/api/json/catalog.json" },
			schemas = require("schemastore").json.schemas(),
		},
	},
}

return Servers
