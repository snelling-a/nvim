local Formatting = {}

local lsp_formatting = function(bufnr)
	vim.lsp.buf.format({
		filter = function(client) return client.name == "null-ls" end,
		bufnr = bufnr,
	})
end

Formatting.lsp_formatting = lsp_formatting

local LspFormattingGroup = vim.api.nvim_create_augroup("LspFormatting", {})

Formatting.format_on_save = function(client, bufnr)
	if not client.supports_method("textDocument/formatting") then
		return
	end

	vim.api.nvim_clear_autocmds({ group = LspFormattingGroup, buffer = bufnr })
	vim.api.nvim_create_autocmd("BufWritePre", {
		group = LspFormattingGroup,
		buffer = bufnr,
		callback = function() lsp_formatting(bufnr) end,
		desc = "LSP format on save",
	})
end

return Formatting
