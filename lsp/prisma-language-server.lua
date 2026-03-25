---@type vim.lsp.Config
return {
	cmd = { "prisma-language-server", "--stdio" },
	filetypes = { "prisma" },
	root_markers = { "schema.prisma", ".git" },
	settings = {
		prisma = {
			prismaFmtBinPath = "",
			enableCodeLens = true,
			enableDiagnostics = true,
		},
	},
}
