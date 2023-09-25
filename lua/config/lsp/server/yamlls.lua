local settings = {
	yaml = {
		hover = true,
		completion = true,
		validate = true,
		schemas = require("schemastore").yaml.schemas(),
	},
}

local M = {}

M.mason_name = "yaml-language-server"

function M.setup(opts)
	opts.settings = settings

	require("lspconfig").yamlls.setup(opts)
end

return M
