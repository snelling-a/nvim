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

function M.setup(opts)
	opts = require("config.lsp.capabilities").enable_broadcasting(opts)

	opts.init_options = init_options

	opts.settings = settings

	require("lspconfig").jsonls.setup(opts)

	vim.api.nvim_create_user_command("SortJSON", function() vim.cmd([[%!jq . --sort-keys]]) end, {
		desc = "Sort json keys alphabetically",
	})
end

return M
