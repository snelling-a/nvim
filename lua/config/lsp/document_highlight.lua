local api = vim.api
local lsp = vim.lsp.buf

local function highlight_references()
	local node = require("nvim-treesitter.ts_utils").get_node_at_cursor()
	while node ~= nil do
		local node_type = node:type()
		if
			node_type == "string"
			or node_type == "string_fragment"
			or node_type == "template_string"
			or node_type == "document"
		then
			return
		end
		node = node:parent()
	end
	lsp.document_highlight()
end

local DocumentHighlight = {}

function DocumentHighlight.on_attach(bufnr)
	local LspDocumentHighlightGroup = require("config.util").augroup("LspDocumentHightlight", false)

	api.nvim_clear_autocmds({ buffer = bufnr, group = LspDocumentHighlightGroup })

	api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
		buffer = bufnr,
		callback = highlight_references,
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
