local M = {}

--- @param client lsp.Client
--- @param bufnr integer
function M.on_attach(client, bufnr)
	local ok, inlay_hint_supported = pcall(function() return client.supports_method("textDocument/inlayHint") end)

	if not ok or not inlay_hint_supported then
		return
	end

	vim.lsp.inlay_hint(bufnr, true)

	vim.api.nvim_create_user_command("InlayHintToggle", function() vim.lsp.inlay_hint(0, nil) end, {
		desc = "Toggle LSP inlay hints",
	})
end

return M
