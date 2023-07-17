local settings = { json = { schemas = require("schemastore").json.schemas(), validate = { enable = true } } }

local Json = {}

Json.mason_name = "json-lsp"

function Json.setup(opts)
	opts = require("config.lsp.capabilities").enable_broadcasting(opts)

	opts.settings = settings

	require("lspconfig").jsonls.setup(opts)
end

return Json
