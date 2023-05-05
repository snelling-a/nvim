local util = require("config.lsp.util")
local M = {}

function M.setup(opts)
	opts.root_dir = util.get_root_pattern({ "*.html" })

	require("lspconfig").html.setup(opts)
end

return M
