local M = {}

local settings = { json = { schemas = require("schemastore").json.schemas(), validate = { enable = true } } }

function M.setup(opts)
	opts = require("config.lsp.capabilities").enable_broadcasting(opts)

	opts.settings = settings

	require("lspconfig").jsonls.setup(opts)
end

return M
