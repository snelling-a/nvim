local util = require("config.lsp.util")
local M = {}

function M.setup(opts)
	opts.init_options = { isNeovim = util.get_root_pattern({ "init.vim", "init.lua" }) }

	require("lspconfig").vimls.setup(opts)
end

return M
