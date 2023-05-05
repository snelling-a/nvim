local settings = {
	yaml = {
		schemas = require("schemastore").yaml.schemas(),
	},
}

local M = {}

function M.setup(opts)
	opts.settings = settings

	require("lspconfig").yamlls.setup(opts)
end

return M
