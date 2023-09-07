local M = {}

M.mason_name = "vim-language-server"

function M.setup(opts)
	opts.init_options = {
		vimruntime = vim.env.VIMRUNTIME,
		runtimepath = vim.o.runtimepath,
	}

	require("lspconfig").vimls.setup(opts)
end

return M
