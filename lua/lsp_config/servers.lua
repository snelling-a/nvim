local lsp_ok, config_util = pcall(require, "lspconfig.util")
if not lsp_ok then
	return
end

local Servers = {}

Servers.awk_ls = {}

Servers.bashls = {}

Servers.denols = { root_dir = config_util.root_pattern("deno.json", "deno.jsonc") }

Servers.emmet_ls = {}

Servers.graphql = { root_dir = config_util.root_pattern(".graphqlrc*", ".graphql.config.*", "graphql.config.*") }

Servers.jsonls =
	{ settings = { json = { schemas = require("schemastore").json.schemas(), validate = { enable = true } } } }

Servers.lua_ls = {
	root_dir = config_util.root_pattern(".luarc.json", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml"),
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
			workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
			runtime = { version = "LuaJIT", path = vim.split(package.path, ";") },
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
