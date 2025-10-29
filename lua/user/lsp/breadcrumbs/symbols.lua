local Winbar = require("user.lsp.breadcrumbs.winbar")
local symbol_clients = {} ---@type table<integer, vim.lsp.Client>

---@param bufnr integer
---@return vim.lsp.Client|nil
local function get_symbol_client(bufnr)
	---@type vim.lsp.Client|nil
	local client = symbol_clients[bufnr]
	if client and client:is_stopped() then
		symbol_clients[bufnr] = nil
		client = nil
	end
	if client then
		return client
	end

	for _, c in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
		if c:supports_method(vim.lsp.protocol.Methods.textDocument_documentSymbol) then
			symbol_clients[bufnr] = c
			return c
		end
	end
end

---@class lsp.breadcrumbs.Symbols
local M = {}

---@param bufnr number
---@return nil
function M.refresh_symbols(bufnr)
	local uri = vim.uri_from_bufnr(bufnr)
	local client = get_symbol_client(bufnr)

	if not client then
		return Winbar.get_winbar()
	end

	client:request(vim.lsp.protocol.Methods.textDocument_documentSymbol, {
		textDocument = { uri = uri },
	}, function(_, result)
		if result then
			Winbar.current_symbols = result
		end
		Winbar.get_winbar()
	end, bufnr)
end

return M
