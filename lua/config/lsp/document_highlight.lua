local Util = require("config.util")

local api = vim.api
local lsp = vim.lsp.buf

local function document_highlight()
	local node = require("nvim-treesitter.ts_utils").get_node_at_cursor()

	while node ~= nil do
		local no_highlight = {
			"document",
			"string",
			"string_fragment",
			"template_string",
			"unknown_builtin_statement",
		}

		local node_type = node:type()

		if vim.tbl_contains(no_highlight, node_type) then
			return
		end

		node = node:parent()
	end

	lsp.document_highlight()
end

local function setup_document_highlight(bufnr)
	local event = {
		"CursorHold",
		"CursorHoldI",
	}

	local opts = {
		group = Util.augroup("LspDocumentHightlight", false),
		buffer = bufnr,
	}

	local ok, hl_autocmds = pcall(
		api.nvim_get_autocmds,
		Util.tbl_extend_force(opts, {
			event = event,
		})
	)

	if ok and #hl_autocmds > 0 then
		return
	end

	api.nvim_create_autocmd(
		event,
		Util.tbl_extend_force(opts, {
			callback = document_highlight,
		})
	)

	api.nvim_create_autocmd(
		{
			"CursorMoved",
			"CursorMovedI",
		},
		Util.tbl_extend_force(opts, {
			callback = lsp.clear_references,
		})
	)
end

local M = {}

function M.on_attach(client, bufnr)
	local ok, highlight_supported = pcall(
		function() return client.supports_method("textDocument/documentHighlight") end
	)

	if not ok or not highlight_supported then
		return
	end

	setup_document_highlight(bufnr)
end

return M
