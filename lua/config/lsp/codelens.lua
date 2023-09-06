local Util = require("config.util")

--- @param bufnr integer
local function setup_codelens_refresh(bufnr)
	local api = vim.api
	local event = {
		"BufEnter",
		"BufWritePost",
		"InsertLeave",
	}

	local opts = {
		group = Util.augroup("LspCodelens"),
		buffer = bufnr,
	}

	local ok, code_lens_autocmd = pcall(
		api.nvim_get_autocmds,
		Util.tbl_extend_force(opts, {
			event = event,
		})
	)

	if ok and #code_lens_autocmd > 0 then
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
	local ok, codelens_supported = pcall(function() return client.supports_method("textDocument/codeLens") end)
	if not ok or not codelens_supported then
		return
	end

	setup_codelens_refresh(bufnr)
end

return M
