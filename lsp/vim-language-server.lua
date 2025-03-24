---@type vim.lsp.Config
return {
	cmd = { "vim-language-server", "--stdio" },
	filetypes = { "vim" },
	init_options = {
		diagnostic = { enable = true },
		indexes = {
			runtimepath = true,
			gap = 100,
			count = 3,
			projectRootPatterns = { "runtime", "nvim", ".git", "autoload", "plugin" },
		},
		isNeovim = true,
		iskeyword = "@,48-57,_,192-255,-#",
		runtimepath = "",
		suggest = { fromVimruntime = true, fromRuntimepath = true },
		vimruntime = "",
	},
	single_file_support = true,
}
