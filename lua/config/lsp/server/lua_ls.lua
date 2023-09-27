local config_files = {
	".luarc.json",
	".luarc.jsonc",
	".luacheckrc",
	".stylua.toml",
	"stylua.toml",
	"selene.toml",
	"selene.yml",
}

local function get_lua_runtime()
	local result = {}
	for _, path in pairs(vim.api.nvim_list_runtime_paths()) do
		local lua_path = path .. "/lua/"
		if vim.fn.isdirectory(lua_path) then
			result[lua_path] = true
		end
	end
	result[vim.fn.expand("$VIMRUNTIME/lua")] = true
	result[vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true

	return result
end

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
			library = get_lua_runtime(),
			maxPreload = 1000,
			preloadFileSize = 1000,
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
