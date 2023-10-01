local Util = require("config.util")

local method = vim.lsp.protocol.Methods.textDocument_documentHighlight

--- @param client lsp.Client
local function document_highlight(client)
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

	local current_buf = vim.api.nvim_get_current_buf()
	local params = vim.lsp.util.make_position_params(0, client.offset_encoding)

	client.request(method, params, nil, current_buf)
end

--- @param client lsp.Client
--- @param bufnr integer
local function setup_document_highlight(client, bufnr)
	local event = {
		"CursorHold",
	}

	local opts = {
		group = Util.augroup("LspDocumentHightlight", false),
		buffer = bufnr,
	}

	local api = vim.api

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
			callback = function() document_highlight(client) end,
		})
	)

	api.nvim_create_autocmd(
		{
			"CursorMoved",
		},
		Util.tbl_extend_force(opts, {
			callback = function() pcall(vim.lsp.buf.clear_references) end,
		})
	)
end

local M = {}

--- @param client lsp.Client
--- @param bufnr integer
function M.on_attach(client, bufnr)
	local ok, highlight_supported = pcall(function() return client.supports_method(method) end)

	if not ok or not highlight_supported then
		return
	end

	setup_document_highlight(client, bufnr)
end

return M
