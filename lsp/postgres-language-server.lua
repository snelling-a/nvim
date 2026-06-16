---@type vim.lsp.Config
return {
	cmd = { "postgres-language-server", "lsp-proxy" },
	filetypes = { "sql" },
	root_markers = { ".git" },
}
