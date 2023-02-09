local lsp_ok, config_util = pcall(require, "lspconfig.util")
if not lsp_ok then
	return
end

local Servers = {}

Servers.denols = { root_dir = config_util.root_pattern("deno.json", "deno.jsonc") }

Servers.jsonls =
	{ settings = { json = { schemas = require("schemastore").json.schemas(), validate = { enable = true } } } }

Servers.lua_ls = {
	root_dir = config_util.root_pattern(".luarc.json", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml"),
	settings = {
		Lua = {
			completion = { callSnippet = "Replace" },
			diagnostics = { enable = false, globals = { "vim" } },
			workspace = { checkThirdParty = false },
		},
	},
}

Servers.graphql = { root_dir = config_util.root_pattern(".graphqlrc*", ".graphql.config.*", "graphql.config.*") }

Servers.vimls = { root_dir = config_util.root_pattern(".vimrc", "dotfiles/nvim/after") }

Servers.taplo = {}

return Servers

--TODO
--awk
-- mkdn
-- bash
--
