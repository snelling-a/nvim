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
	vim.api.nvim_create_user_command("SortYAML", function() vim.cmd([[%!yq 'sort_keys(..)' %]]) end, {
		desc = "Sort yaml keys alphabetically",
	})
end

return M
