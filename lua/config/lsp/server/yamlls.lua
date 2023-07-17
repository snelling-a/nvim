local settings = {
	yaml = {
		hover = true,
		completion = true,
		validate = true,
		schemas = require("schemastore").yaml.schemas(),
	},
}

local Yaml = {}

Yaml.mason_name = "yaml-language-server"

function Yaml.setup(opts)
	opts.settings = settings

	require("lspconfig").yamlls.setup(opts)
end

return Yaml
