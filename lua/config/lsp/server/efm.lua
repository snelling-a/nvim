local js_ts_filetypes = require("config.util.constants").javascript_typescript
local prettierd = require("config.lsp.efm.prettierd").setup()
local shfmt = require("config.lsp.efm.shfmt")

local languages = {}

local function add_languages(filetypes, config)
	for _, v in ipairs(filetypes) do
		languages[v] = config
	end
end

add_languages(js_ts_filetypes, {
	require("config.lsp.efm.eslint").setup(),
	prettierd,
})
add_languages({
	"bash",
	"sh",
}, {
	shfmt.setup(),
	require("config.lsp.efm.shellcheck").setup(),
})

languages.css = {
	prettierd,
}
languages.html = {
	prettierd,
}
languages.json = {
	require("config.lsp.efm.jq").setup(),
}
languages.jsonc = {
	require("config.lsp.efm.prettier").setup("json"),
}
languages.lua = {
	require("config.lsp.efm.luacheck").setup(),
	require("config.lsp.efm.stylua").setup(),
}
languages.markdown = {
	require("config.lsp.efm.cbfmt").setup(),
	prettierd,
}
languages.yaml = {
	require("config.lsp.efm.yamllint").setup(),
	require("config.lsp.efm.yamlfmt").setup(),
}
languages.zsh = {
	shfmt.setup(),
}
languages["="] = {
	require("config.lsp.efm.cspell").setup(),
}
languages.toml = {
	nil,
}

local settings = {
	languages = languages,
}

local M = {}

function M.setup(opts)
	opts.init_options = {
		documentFormatting = true,
		hover = true,
		documentSymbol = true,
		codeAction = true,
		completion = true,
	}
	opts.settings = settings

	require("lspconfig").efm.setup(opts)
end

return M
