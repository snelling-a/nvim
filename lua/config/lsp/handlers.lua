local lsp = vim.lsp
local handlers = lsp.handlers

local border_override = {
	border = "rounded",
}

	handlers["textDocument/definition"] = function(_, result)
		if not result or vim.tbl_isempty(result) then
			logger.warn({ msg = "[LSP] Could not find definition", title = "LSP" })
			return
		end
local M = {}

		if vim.tbl_islist(result) then
			util.jump_to_location(result[1], "utf-8")
		else
			util.jump_to_location(result, "utf-8")
		end
	end
function M.on_attach()
	handlers["textDocument/publishDiagnostics"] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
		signs = true,
	})
	handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, border_override)
	handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, border_override)
end

return M
