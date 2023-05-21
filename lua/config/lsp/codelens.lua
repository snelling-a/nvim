local util = require("config.util")

local api = vim.api
local lsp = vim.lsp

local function create_codelens_autocmd(bufnr)
	api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "BufWritePost", "CursorHold" }, {
		buffer = bufnr,
		desc = "Refresh codelens",
		group = util.augroup("LspCodelens" .. "." .. bufnr),
		callback = function() lsp.codelens.refresh() end,
	})
end

local CodeLens = {}

function CodeLens.on_attach(bufnr)
	api.nvim_create_autocmd("LspAttach", {
		callback = function()
			create_codelens_autocmd(bufnr)
			vim.schedule(lsp.codelens.refresh)
		end,
		desc = "Initialize codelens",
		group = util.augroup("LspCodlens"),
	})
end

return CodeLens
