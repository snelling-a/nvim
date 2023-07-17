local Html = {}

Html.mason_name = "html-lsp"

function Html.setup(opts)
	opts.root_dir = require("config.lsp.util").get_root_pattern({ "*.html" })

	require("lspconfig").html.setup(opts)
end

return Html
