local lsp = vim.lsp
local handlers = lsp.handlers
local Methods = vim.lsp.protocol.Methods

local border_override = {
	border = "rounded",
}

local M = {}

function M.on_attach()
	handlers[Methods.textDocument_definition] = require("config.lsp.definition").handler
	handlers[Methods.textDocument_hover] = vim.lsp.with(vim.lsp.handlers.hover, border_override)
	handlers[Methods.textDocument_publishDiagnostics] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
		signs = true,
	})
	handlers[Methods.textDocument_signatureHelp] = vim.lsp.with(vim.lsp.handlers.signature_help, border_override)
end

return M
