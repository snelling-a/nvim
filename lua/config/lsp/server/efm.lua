local languages = {}

local function require_efm_config(file_name, args) return require("config.lsp.efm." .. file_name).setup(args or nil) end

local function add_languages(filetypes, config)
	for _, v in ipairs(filetypes) do
		languages[v] = config
	end
end

local js_ts_filetypes = vim.fn.deepcopy(require("config.util.constants").javascript_typescript)

local shfmt = require_efm_config("shfmt")

add_languages(js_ts_filetypes, {
	require_efm_config("eslint"),
	require_efm_config("prettierd"),
})
add_languages({
	"bash",
	"sh",
}, {
	shfmt,
	require_efm_config("shellcheck"),
})

languages.html = {
	require_efm_config("prettier", "html"),
}
languages.json = {
	require_efm_config("jq"),
}
languages.jsonc = {
	require_efm_config("prettier", "json"),
}
languages.lua = {
	require_efm_config("luacheck"),
	require_efm_config("stylua"),
}
languages.markdown = {
	require_efm_config("cbfmt"),
}
languages.yaml = {
	require_efm_config("yamllint"),
	require_efm_config("yamlfmt"),
}
languages.zsh = {
	shfmt,
}
languages["="] = {
	require_efm_config("cspell"),
}
languages.toml = { nil }

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
