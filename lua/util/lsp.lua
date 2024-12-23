---@class util.Lsp
local M = {}

---@param name string Client name
---@param config vim.lsp.Config
function M.add(name, config)
	print("Adding LSP client: " .. name)
	vim.lsp.config(name, config)
	vim.lsp.enable(name)
end

return M
