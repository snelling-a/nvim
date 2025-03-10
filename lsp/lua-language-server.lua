---@type vim.lsp.Config
return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	name = "lua_ls",
	root_markers = {
		"lua/",
		".luacheckrc",
		".luarc.json",
		".luarc.jsonc",
		"selene.toml",
		"selene.yml",
		".stylua.toml",
		"stylua.toml",
	},
	settings = {
		Lua = {
			completion = { callSnippet = "Replace", displayContext = 5 },
			diagnostics = {
				globals = { "vim" },
				groupFileStatus = {
					["ambiguity"] = "Opened",
					["await"] = "Opened",
					["codestyle"] = "None",
					["duplicate"] = "Opened",
					["global"] = "Opened",
					["luadoc"] = "Opened",
					["redefined"] = "Opened",
					["strict"] = "Opened",
					["strong"] = "Opened",
					["type-check"] = "Opened",
					["unbalanced"] = "Opened",
					["unused"] = "Opened",
				},
				libraryFiles = "Disable",
				unusedLocalExclude = { "_*" },
				workspaceEvent = "OnChange",
			},
			doc = { privateName = { "^_" } },
			format = { enable = false },

			hint = {
				arrayIndex = "Disable",
				enable = true,
				semicolon = "Disable",
				setType = true,
				paramName = "Literal",
			},
			runtime = {
				version = "LuaJIT",
				path = { "lua/?.lua", "lua/?/init.lua" },
			},
			telemetry = { enable = false },
			window = { progressBar = true },
			workspace = { checkThirdParty = false, library = vim.api.nvim_get_runtime_file("", true) },
		},
	},
}
