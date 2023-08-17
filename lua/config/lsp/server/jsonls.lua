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

local Json = {}

Json.mason_name = "json-lsp"

function Json.setup(opts)
	opts = require("config.lsp.capabilities").enable_broadcasting(opts)

	opts.init_options = init_options

	opts.settings = settings

	require("lspconfig").jsonls.setup(opts)
end

return Json
