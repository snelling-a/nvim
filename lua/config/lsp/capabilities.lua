local protocol = vim.lsp.protocol

--- use default capabilities to create cmp capabilities
--- @param capabilities lsp.ClientCapabilities
--- @return lsp.ClientCapabilities
local function cmp_wrapper(capabilities)
	local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if not ok then
		return {}
	end

	return cmp_nvim_lsp.default_capabilities(capabilities)
end

local M = {}

--- wrapper for tbl_extend.completion.completionItem.snippetSupport
--- to enable (broadcasting) snippet capability for completion
--- @param opts table
--- @return table
function M.enable_broadcasting(opts)
	local capabilities = protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true

	capabilities = cmp_wrapper(capabilities)

	opts.capabilities = require("config.util").tbl_extend_force(opts.capabilities or {}, capabilities)

	return opts
end

function M.get_capabilities()
	local capabilities = protocol.make_client_capabilities()
	capabilities = {
		textDocument = {
			foldingRange = {
				dynamicRegistration = false,
				lineFoldingOnly = true,
			},
			completion = {
				completionItem = {
					snippetSupport = true,
					resolveSupport = {
						properties = {
							"documentation",
							"detail",
							"additionalTextEdits",
						},
					},
				},
			},
			codeAction = {
				resolveSupport = {
					properties = vim.list_extend(capabilities.textDocument.codeAction.resolveSupport.properties, {
						"documentation",
						"detail",
						"additionalTextEdits",
					}),
				},
			},
		},
	}

	capabilities = cmp_wrapper(capabilities)

	return capabilities
end

return M
