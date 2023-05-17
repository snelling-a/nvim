local fzf_lua = require("fzf-lua")
local logger = require("config.util.logger")
local handlers = vim.lsp.handlers
local lsp = vim.lsp
local util = vim.lsp.util

local Handlers = {}

function Handlers.on_attach()
	handlers["callHierarchy/incomingCalls"] = fzf_lua.lsp_incoming_calls
	handlers["callHierarchy/outgoingCalls"] = fzf_lua.lsp_outgoing_calls
	handlers["textDocument/declaration"] = fzf_lua.lsp_declarations
	handlers["textDocument/definition"] = function(_, result)
		if not result or vim.tbl_isempty(result) then
			logger.warn({ msg = "[LSP] Could not find definition", title = "LSP" })
			return
		end
		if vim.tbl_islist(result) then
			util.jump_to_location(result[1], "utf-8")
		else
			util.jump_to_location(result, "utf-8")
		end
	end
	handlers["textDocument/documentSymbol"] = fzf_lua.lsp_document_symbols
	handlers["textDocument/implementation"] = fzf_lua.lsp_implementations
	handlers["textDocument/publishDiagnostics"] = lsp.with(lsp.diagnostic.on_publish_diagnostics, { signs = true })
	handlers["textDocument/references"] = fzf_lua.lsp_references
	handlers["workspace/symbol"] = fzf_lua.lsp_workspace_symbols
end

return Handlers
