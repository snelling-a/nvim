local Css = {}

Css.mason_name = "css-lsp"

function Css.setup(opts)
	opts = require("config.lsp.capabilities").enable_broadcasting(opts)

	require("lspconfig").cssls.setup(opts)
end

return Css
