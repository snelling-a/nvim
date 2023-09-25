local settings = {
	json = {
		schemas = require("schemastore").json.schemas(),
		validate = {
			enable = true,
		},
	},
}

local init_options = {
	provideFormatter = false,
}

local M = {}

M.mason_name = "json-lsp"

--- @param opts lspconfig.Config
function M.setup(opts)
	opts = require("config.lsp.capabilities").enable_broadcasting(opts)

	opts.init_options = init_options

	opts.settings = settings

	require("lspconfig").jsonls.setup(opts)
end

return M
