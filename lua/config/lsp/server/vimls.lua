local Vim = {}

Vim.mason_name = "vim-language-server"

function Vim.setup(opts)
	opts.init_options = { isNeovim = require("config.lsp.util").get_root_pattern({ "init.vim", "init.lua" }) }

	require("lspconfig").vimls.setup(opts)
end

return Vim
