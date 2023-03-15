local lsp_config = {}

lsp_config.servers = require("lsp_config.servers")

local diagnostics = require("lsp_config.diagnostics")
local document_highlighting = require("lsp_config.document_highlight")
local formatting = require("lsp_config.formatting")
local handlers = require("lsp_config.handlers")
local mappings = require("lsp_config.mappings")

lsp_config.setup = function()
	vim.diagnostic.config({
		current_line_virt = true,
		float = { source = "always", border = "rounded" },
		severity_sort = true,
		signs = true,
		underline = true,
		update_in_insert = false,
		virtual_text = false,
	})
end

lsp_config.on_attach = function(client, bufnr)
	if client.name == "tsserver" then
		client.server_capabilities.documentFormattingProvider = false -- 0.8 and later
	end

	mappings(bufnr)
	handlers()
	formatting(client, bufnr)
	document_highlighting(client, bufnr)
	diagnostics(bufnr)
end

return lsp_config
