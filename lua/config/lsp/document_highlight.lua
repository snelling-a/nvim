local api = vim.api
local lsp = vim.lsp.buf

local function highlight_references()
	local node = require("nvim-treesitter.ts_utils").get_node_at_cursor()
	local no_highlight = { "string", "string_fragment", "template_string", "document" }

	while node ~= nil do
		local node_type = node:type()

		if vim.tbl_contains(no_highlight, node_type) then
			return
		end

		node = node:parent()

	end

	lsp.document_highlight()
end

local M = {}

function M.on_attach(bufnr)
	local LspDocumentHighlightGroup = require("config.util").augroup("LspDocumentHightlight", false)

	api.nvim_clear_autocmds({
		buffer = bufnr,
		group = LspDocumentHighlightGroup,
	})

	api.nvim_create_autocmd({
		"CursorHold",
		"CursorHoldI",
	}, {
		buffer = bufnr,
		callback = highlight_references,
		desc = "Highlight all occurrences of the word under the cursor",
		group = LspDocumentHighlightGroup,
	})

	api.nvim_create_autocmd({
		"CursorMoved",
		"CursorMovedI",
	}, {
		buffer = bufnr,
		callback = function() lsp.clear_references() end,
		desc = "Clear highlighted references on cursor move",
		group = LspDocumentHighlightGroup,
	})
end

return M
