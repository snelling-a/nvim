local config_files =
	{ ".luarc.json", ".luarc.jsonc", ".luacheckrc", ".stylua.toml", "stylua.toml", "selene.toml", "selene.yml" }

local settings = {
	Lua = {
		codeLens = { enable = true },
		diagnostics = { globals = { "vim" } },
		format = { enable = false },
		hint = {
			arrayIndex = "Disable",
			await = true,
			enable = true,
			paramName = "Literal",
			paramType = true,
			semicolon = "Disable",
			setType = true,
		},
		unusedLocalExclude = { "_*" },
		workspace = { checkThirdParty = false },
	},
}

local Lua = {}

Lua.mason_name = "lua-language-server"

function Lua.setup(opts)
	require("neodev").setup()

	opts.root_dir = require("config.lsp.util").get_root_pattern(config_files)

	opts.settings = settings

	require("lspconfig").lua_ls.setup(opts)
	vim.api.nvim_create_user_command("FormatLua", function()
		vim.api.nvim_exec2(
			[[
            silent! %s/\(\s\+\)\?\(\w\?\(,\|(\)\?\s\?\(=\s\)\?{\)\(\s\S\)/\1\2\r\5/
            silent! %s/\s\+{\s\?{/{\r{/
            silent! %s/{\n\{2,\}/{\r/
            ]],
			{ output = false }
		)

		vim.cmd.write()
	end, { desc = "Ensure consistent formatting of lua tables", force = true })
end

return Lua
