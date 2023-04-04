local api = vim.api
local lsp = vim.lsp

return function(client, bufnr)
	if not client.supports_method("textDocument/documentHighlight") then
		return
	end

	local LspDocumentHighlightGroup = api.nvim_create_augroup("LspDocumentHightlight", { clear = false })

	api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
		group = LspDocumentHighlightGroup,
		buffer = bufnr,
		callback = lsp.buf.document_highlight,
		desc = "Highlight all occurrences of the word under the cursor",
	})

	api.nvim_create_autocmd("CursorMoved", {
		group = LspDocumentHighlightGroup,
		buffer = bufnr,
		callback = lsp.buf.clear_references,
		desc = "Clear all references on cursor move",
	})
end
