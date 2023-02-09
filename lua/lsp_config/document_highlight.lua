local utils = require("utils")

return function(client, bufnr)
	if not client.supports_method("textDocument/documentHighlight") then
		return
	end

	local LspDocumentHighlightGroup = utils.augroup("LspDocumentHightlight", { clear = false })

	utils.autocmd({ "CursorHold", "CursorHoldI" }, {
		group = LspDocumentHighlightGroup,
		buffer = bufnr,
		callback = vim.lsp.buf.document_highlight,
		desc = "Highlight all occurrences of the word under the cursor",
	})

	utils.autocmd("CursorMoved", {
		group = LspDocumentHighlightGroup,
		buffer = bufnr,
		callback = vim.lsp.buf.clear_references,
		desc = "Clear all references on cursor move",
	})
end
