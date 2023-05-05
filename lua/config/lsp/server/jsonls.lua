local M = {}

local settings = { json = { schemas = require("schemastore").json.schemas(), validate = { enable = true } } }
local util = require("config.lsp.util")

function M.setup(opts)
	opts = util.enable_broadcasting(opts)

	opts.settings = settings

	require("lspconfig").jsonls.setup(opts)
end

return M
