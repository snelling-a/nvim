local util = require("config.util")

local M = {}

---wrapper for lspconfig.util.root_pattern
---@param config_files string[]
---@return function (startpath: any) -> string|unknown|nil
function M.get_root_pattern(config_files) return require("lspconfig").util.root_pattern(unpack(config_files)) end

---wrapper for tbl_extend.completion.completionItem.snippetSupport
---@param opts table
---@return table
function M.enable_broadcasting(opts)
	--Enable (broadcasting) snippet capability for completion
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true

	opts.capabilities = util.tbl_extend_force(opts.capabilities or {}, capabilities)

	return opts
end

---wrapper for lspconfig.util.root_pattern for graphql language servers
---@return function (startpath: any) -> string|unknown|nil
function M.get_graphql_root_pattern()
	return require("lspconfig").util.root_pattern({
		".graphqlrc*",
		".graphql.config.*",
		"graphql.config.*",
		"relay.config.*",
	})
end

return M
