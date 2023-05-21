local navic = require("nvim-navic")

local LspConfig = {}

function LspConfig.on_attach(client, bufnr)
	if client.name == "tsserver" then
		client.server_capabilities.documentFormattingProvider = false
	end

	if client.server_capabilities.documentSymbolProvider then
		navic.attach(client, bufnr)
	end

	if client.server_capabilities.documentFormattingProvider == true then
		require("config.lsp.formatting").on_attach(bufnr)
	end

	if client.supports_method("textDocument/documentHighlight") then
		require("config.lsp.document_highlight").on_attach(bufnr)
	end

	if client.server_capabilities.inlayHintProvider then
		require("lsp-inlayhints").on_attach(client, bufnr, true)
	end

	require("config.lsp.handlers").on_attach()

	if client.supports_method("textDocument/publishDiagnostics") then
		require("config.lsp.diagnostic").on_attach(bufnr)
	end

	if client.supports_method("textDocument/codeLens") then
		require("config.lsp.codelens").on_attach(bufnr)
	end

	require("config.lsp.keymap").on_attach(bufnr)
end

return LspConfig
