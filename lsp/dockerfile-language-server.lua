---@type vim.lsp.Config
return {
	cmd = { "docker-langserver", "--stdio" },
	filetypes = { "dockerfile" },
	single_file_support = true,
}
