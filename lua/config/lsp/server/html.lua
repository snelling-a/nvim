local M = {}

M.mason_name = "html-lsp"

function M.setup(opts)
	opts.root_dir = require("config.lsp.util").get_root_pattern({
		"*.html",
	})

	require("lspconfig").html.setup(opts)
end

return M
