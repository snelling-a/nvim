local lsp_formatting = function(bufnr)
	vim.lsp.buf.format({
		filter = function(client)
			-- apply whatever logic you want (in this example, we'll only use null-ls)
			return client.name == "null-ls"
		end,
		bufnr = bufnr,
	})
end

local LspFormattingGroup = vim.api.nvim_create_augroup("LspFormatting", {})

return function(client, bufnr)
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
