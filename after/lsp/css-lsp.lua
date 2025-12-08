---@type vim.lsp.Config
return {
	cmd = { "vscode-css-language-server", "--stdio" },
	filetypes = { "css", "scss", "less" },
	name = "css_ls",
	root_markers = { ".git", "package.json" },
	settings = {
		css = { validate = true },
		scss = { validate = true },
		less = { validate = true },
	},
}

