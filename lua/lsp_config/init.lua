local lsp_config = {}

lsp_config.servers = require("lsp_config.servers")

local diagnostics = require("lsp_config.diagnostics")
local document_highlighting = require("lsp_config.document_highlight")
local format_on_save = require("lsp_config.formatting").format_on_save
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
		client.server_capabilities.documentFormattingProvider = false
	end

	mappings(bufnr)
	handlers()
	format_on_save(client, bufnr)
	document_highlighting(client, bufnr)
	diagnostics(bufnr)
end

return lsp_config
