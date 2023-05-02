local api = vim.api
local lsp = vim.lsp.buf

local DocumentHighlight = {}

function DocumentHighlight.on_attach(bufnr)
	local LspDocumentHighlightGroup = api.nvim_create_augroup("LspDocumentHightlight", { clear = false })

	vim.api.nvim_clear_autocmds({ buffer = bufnr, group = LspDocumentHighlightGroup })

	api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
		group = LspDocumentHighlightGroup,
		buffer = bufnr,
		callback = lsp.document_highlight,
		desc = "Highlight all occurrences of the word under the cursor",
	})

	api.nvim_create_autocmd("CursorMoved", {
		group = LspDocumentHighlightGroup,
		buffer = bufnr,
		callback = lsp.clear_references,
		desc = "Clear highlighted references on cursor move",
	})
end

return DocumentHighlight
