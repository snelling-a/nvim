local util = require("config.util")

local protocol = vim.lsp.protocol

local M = {}

---wrapper for vim.api.nvim_buf_set_keymap
---@param bufnr integer 'buffer number'
---@param lhs string 'keymap'
---@param rhs string|function 'keymap functionality'
---@param desc string description
function M.bind(bufnr, lhs, rhs, desc)
	local opts = { buffer = bufnr, desc = desc }

	return util.nmap(lhs, rhs, opts)
end
---wrapper for lspconfig.util.root_pattern
---@param config_files string[]
---@return function (startpath: any) -> string|unknown|nil
function M.get_root_pattern(config_files) return require("lspconfig").util.root_pattern(unpack(config_files)) end

---wrapper for tbl_extend.completion.completionItem.snippetSupport
---@param opts table
---@return table
function M.enable_broadcasting(opts)
	--Enable (broadcasting) snippet capability for completion
	local capabilities = protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true

	opts.capabilities = util.tbl_extend_force(opts.capabilities or {}, capabilities)

	return opts
end

---wrapper for lspconfig.util.root_pattern for graphql language servers
---@return function (startpath: any) -> string|unknown|nil
function M.get_graphql_root_pattern()
	return M.get_root_pattern({
		".graphqlrc*",
		".graphql.config.*",
		"graphql.config.*",
		"relay.config.*",
	})
end

function M.get_capabilities()
	local capabilities = protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.completion.completionItem.resolveSupport = {
		properties = { "documentation", "detail", "additionalTextEdits" },
	}
	capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

	return capabilities
end

return M
