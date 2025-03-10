---@type vim.lsp.Config
return {
	cmd = { "docker-compose-langserver", "--stdio" },
	filetypes = { "yaml.docker-compose" },
	single_file_support = true,
}
