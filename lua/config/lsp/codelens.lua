local Util = require("config.util")

--- @param bufnr integer
local function setup_codelens(bufnr)
	local api = vim.api
	local event = {
		"BufEnter",
		"BufWritePost",
		"CursorHold",
		"InsertLeave",
	}

	local opts = {
		group = Util.augroup("LspCodelens"),
		buffer = bufnr,
	}

	local exists, code_lens_autocmd = pcall(
		api.nvim_get_autocmds,
		Util.tbl_extend_force(opts, {
			event = event,
		})
	)

	if exists and #code_lens_autocmd > 0 then
		return
	end

	api.nvim_create_autocmd(
		event,
		Util.tbl_extend_force(opts, {
			callback = vim.lsp.codelens.refresh,
		})
	)
end

local M = {}

--- @param client lsp.Client
--- @param bufnr integer
function M.on_attach(client, bufnr)
	local method = vim.lsp.protocol.Methods.textDocument_codeLens

	local ok, codelens_supported = pcall(function() return client.supports_method(method) end)

	if not ok or not codelens_supported then
		return
	end

	setup_codelens(bufnr)
end

return M
