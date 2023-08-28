local M = {}

M.mason_name = "vim-language-server"

function M.setup(opts)
	opts.init_options = { isNeovim = require("config.lsp.util").get_root_pattern({ "init.vim", "init.lua" }) }

	require("lspconfig").vimls.setup(opts)
end

return M
