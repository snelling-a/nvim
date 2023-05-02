local is_okay, telescope = pcall(require, "telescope.builtin")
local handlers = vim.lsp.handlers
local lsp = vim.lsp

if is_okay then
	return function()
		handlers["textDocument/documentSymbol"] = telescope.lsp_document_symbols
		handlers["textDocument/hover"] = lsp.with(handlers.hover, { border = "rounded" })
		handlers["textDocument/publishDiagnostics"] =
			lsp.with(handlers["textDocument/publishDiagnostics"], { signs = true, virtual_text = false })
		handlers["textDocument/references"] = telescope.lsp_references
		handlers["textDocument/signatureHelp"] = lsp.with(handlers.signature_help, { border = "rounded" })
		handlers["textdocument/definition"] = telescope.lsp_definitions
		handlers["textdocument/implementation"] = telescope.lsp_implementations
		handlers["textDocument/documentSymbol"] = telescope.lsp_document_symbols
		handlers["workspace/symbol"] = telescope.lsp_workspace_symbols
	end
end
