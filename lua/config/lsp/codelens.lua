local Util = require("config.util")

local api = vim.api
local lsp = vim.lsp

local group = Util.augroup("LspCodelens")

local function create_codelens_autocmd(bufnr)
	api.nvim_create_autocmd({
		"BufEnter",
		"BufWritePost",
		"InsertLeave",
	}, {
		buffer = bufnr,
		callback = function() lsp.codelens.refresh() end,
		desc = "Refresh codelens",
		group = group,
	})
end

local M = {}

function M.on_attach(bufnr)
	api.nvim_create_autocmd({
		"LspAttach",
	}, {
		callback = function()
			create_codelens_autocmd(bufnr)

			vim.schedule(lsp.codelens.refresh)
		end,
		desc = "Initialize codelens",
		group = group,
	})
end

return M
