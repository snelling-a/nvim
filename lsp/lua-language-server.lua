local library = {
	"${3rd}/luv/library",
	vim.env.VIMRUNTIME .. "/lua",
}

for _, path in ipairs(vim.fn.glob(vim.fn.stdpath("data") .. "/site/pack/*/opt/*/lua", false, true)) do
	table.insert(library, path)
end

---@type vim.lsp.Config
return {
	cmd = { "lua-language-server" },
	filetypes = { "lua" },
	root_markers = {
		".luarc.json",
		".luarc.jsonc",
		".luacheckrc",
		".stylua.toml",
		"stylua.toml",
		"selene.toml",
		"selene.yml",
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
			doc = {
				privateName = { "^_" },
			},
			format = { enable = false },
			hint = {
				arrayIndex = "Disable",
				enable = true,
				paramName = "Literal",
				semicolon = "Disable",
				setType = true,
			},
			runtime = {
				path = { "?/init.lua", "lua/?.lua", "lua/?/init.lua" },
				version = "LuaJIT",
			},
			telemetry = { enable = false },
			window = { progressBar = true },
			workspace = {
				checkThirdParty = false,
				library = library,
			},
		},
	},
}
