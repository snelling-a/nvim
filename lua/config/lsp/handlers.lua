local fzf_lua = require("fzf-lua")
local handlers = vim.lsp.handlers
local lsp = vim.lsp

local Handlers = {}

function Handlers.on_attach()
	handlers["textDocument/documentSymbol"] = fzf_lua.lsp_document_symbols
	-- handlers["textDocument/hover"] = lsp.with(handlers.hover, { border = "rounded" })
	handlers["textDocument/publishDiagnostics"] =
		lsp.with(handlers["textDocument/publishDiagnostics"], { signs = true, virtual_text = false })
	handlers["textDocument/references"] = fzf_lua.lsp_references
	-- handlers["textDocument/signatureHelp"] = lsp.with(handlers.signature_help, { border = "rounded" })
	handlers["textdocument/definition"] = fzf_lua.lsp_definitions
	handlers["textdocument/implementation"] = fzf_lua.lsp_implementations
	handlers["textDocument/documentSymbol"] = fzf_lua.lsp_document_symbols
	handlers["workspace/symbol"] = fzf_lua.lsp_workspace_symbols
end

return Handlers
