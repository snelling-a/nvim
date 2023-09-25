local settings = {
	css = {
		validate = true,
	},
	less = {
		validate = true,
	},
	scss = {
		validate = true,
	},
}

local M = {}

M.mason_name = "css-lsp"

--- @param opts lspconfig.Config
function M.setup(opts)
	opts = require("config.lsp.capabilities").enable_broadcasting(opts)

	opts.settings = settings

	require("lspconfig").cssls.setup(opts)
end

return M
