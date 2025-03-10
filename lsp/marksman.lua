---@type vim.lsp.Config
return {
	cmd = { "marksman", "server" },
	filetypes = { "markdown", "markdown.mdx" },
	root_dir = vim.fs.dirname(vim.fs.find(".git", { upward = true })[1]),
	root_markers = { ".marksman.toml" },
	single_file_support = true,
}
