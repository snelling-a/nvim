local LspConfig = {}

function LspConfig.on_attach(client, bufnr)
	require("config.lsp.codelens").on_attach(client, bufnr)
	require("config.lsp.definition").on_attach(client, bufnr)
	require("config.lsp.diagnostic").on_attach(client, bufnr)
	require("config.lsp.document_highlight").on_attach(client, bufnr)
	require("config.lsp.formatting").on_attach(client, bufnr)
	require("config.lsp.handlers").on_attach()
	require("config.lsp.inlay_hint").on_attach(client, bufnr)
	require("config.lsp.keymap").on_attach(bufnr)
end

return LspConfig
