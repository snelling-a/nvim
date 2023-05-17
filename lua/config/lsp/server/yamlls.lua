local settings = {
	yaml = {
		hover = true,
		completion = true,
		validate = true,
		schemas = require("schemastore").yaml.schemas(),
	},
}

local M = {}

function M.setup(opts)
	opts.settings = settings

	require("lspconfig").yamlls.setup(opts)
end

return M
