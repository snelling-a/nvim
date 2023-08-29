local util = require("config.util")

local protocol = vim.lsp.protocol

--- use default capabilities to create cmp capabilities
--- @param capabilities table
--- @return table
local function cmp_wrapper(capabilities) return require("cmp_nvim_lsp").default_capabilities(capabilities) end

local M = {}

--- wrapper for tbl_extend.completion.completionItem.snippetSupport
--- to enable (broadcasting) snippet capability for completion
--- @param opts table
--- @return table
function M.enable_broadcasting(opts)
	local capabilities = protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true

	capabilities = cmp_wrapper(capabilities)

	opts.capabilities = util.tbl_extend_force(opts.capabilities or {}, capabilities)

	return opts
end

function M.get_capabilities()
	local capabilities = protocol.make_client_capabilities()
	capabilities = {
		textDocument = {
			foldingRange = { dynamicRegistration = false, lineFoldingOnly = true },
			completion = {
				completionItem = {
					snippetSupport = true,
					resolveSupport = { properties = { "documentation", "detail", "additionalTextEdits" } },
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
