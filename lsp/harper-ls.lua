---@type vim.lsp.Config
return {
	cmd = { "harper-ls", "--stdio" },
	filetypes = { "gitcommit", "html", "markdown", "toml" },
	single_file_support = true,
	settings = {
		["harper-ls"] = {
			linters = { avoid_curses = false },
			userDictPath = vim.o.spellfile,
		},
	},
}
