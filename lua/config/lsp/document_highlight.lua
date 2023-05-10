local api = vim.api
local lsp = vim.lsp.buf

local DocumentHighlight = {}

function DocumentHighlight.on_attach(bufnr)
	local LspDocumentHighlightGroup = require("config.util").augroup("LspDocumentHightlight", false)

	api.nvim_clear_autocmds({ buffer = bufnr, group = LspDocumentHighlightGroup })

	api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
		buffer = bufnr,
		callback = lsp.document_highlight,
		desc = "Highlight all occurrences of the word under the cursor",
		group = LspDocumentHighlightGroup,
	})

	api.nvim_create_autocmd("CursorMoved", {
		buffer = bufnr,
		callback = lsp.clear_references,
		desc = "Clear highlighted references on cursor move",
		group = LspDocumentHighlightGroup,
	})
end

return DocumentHighlight
