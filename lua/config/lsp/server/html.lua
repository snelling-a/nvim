local config_files = {
	"*.html",
}

local M = {}

M.mason_name = "html-lsp"

--- @param opts lspconfig.Config
function M.setup(opts)
	opts.root_dir = require("config.lsp.util").get_root_pattern(config_files)

	require("lspconfig").html.setup(opts)
end

return M
