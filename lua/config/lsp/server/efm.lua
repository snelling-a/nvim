local js_ts_filetypes = require("config.util.constants").javascript_typescript
local prettierd = require("config.lsp.efm.prettierd").config
local shfmt = require("config.lsp.efm.shfmt").config

local languages = {
	css = {
		prettierd,
	},
	html = {
		prettierd,
	},
	json = {
		prettierd,
		require("config.lsp.efm.jq").config,
	},
	jsonc = {
		prettierd,
	},
	lua = {
		require("config.lsp.efm.luacheck").config,
		require("config.lsp.efm.stylua").config,
	},
	markdown = {
		prettierd,
		require("config.lsp.efm.cbfmt").config,
	},
	vim = {
		require("config.lsp.efm.vint").config,
	},
	yaml = {
		require("config.lsp.efm.yamlfmt").config,
		require("config.lsp.efm.yamllint").config,
	},
	zsh = {
		shfmt.config,
	},
	["="] = {
		require("config.lsp.efm.cspell").config,
	},
}

local function add_languages(filetypes, config)
	for _, v in ipairs(filetypes) do
		languages[v] = config
	end
end

add_languages(js_ts_filetypes, {
	prettierd,
	require("config.lsp.efm.eslint").config,
})
add_languages({
	"bash",
	"sh",
}, {
	require("config.lsp.efm.shellcheck").config,
	shfmt,
})

local M = {}

--- @param opts lspconfig.Config
function M.setup(opts)
	opts.init_options = {
		documentFormatting = true,
		hover = true,
		documentSymbol = true,
		codeAction = true,
		completion = true,
	}

	opts.settings.languages = languages

	require("lspconfig").efm.setup(opts)
end

return M
