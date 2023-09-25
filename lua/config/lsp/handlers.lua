local lsp = vim.lsp
local handlers = lsp.handlers

local border_override = {
	border = "rounded",
}

local M = {}

function M.on_attach()
	handlers["textDocument/definition"] = require("config.lsp.definition").handler
	handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, border_override)
	handlers["textDocument/publishDiagnostics"] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
		signs = true,
	})
	handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, border_override)
end

return M
