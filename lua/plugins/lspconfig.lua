local Util = require("config.lsp.util")
local javascript_typescript = require("config.util.constants").javascript_typescript

--- @type LazySpec
local M = {
	"neovim/nvim-lspconfig",
}

M.dependencies = {
	{
		"b0o/schemastore.nvim",
		ft = {
			"json",
			"jsonc",
			"yaml",
			"yml",
		},
	},
	{
		"jparise/vim-graphql",
		ft = require("config.util").tbl_extend_force(javascript_typescript, {
			"graphql",
		}),
	},
}

M.event = {
	"BufAdd",
	"SessionLoadPost",
}

function M.config()
	require("lspconfig.ui.windows").default_options.border = "rounded"

	local Path = require("config.util.path")

	Util.ensure_installed(Path.linters_formatters)

	local opts = Util.get_opts()

	local function cb(path) require(path).setup(opts) end

	Util.ensure_installed(Path.lsp_servers, cb)
end

return M
