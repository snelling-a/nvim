---@type vim.lsp.Config
return {
	cmd = { "vim-language-server", "--stdio" },
	filetypes = { "vim" },
	root_dir = vim.fs.dirname(vim.fs.find(".git", { upward = true })[1]),
	single_file_support = true,
	init_options = {
		isNeovim = true,
		iskeyword = "@,48-57,_,192-255,-#",
		vimruntime = "",
		runtimepath = "",
		diagnostic = { enable = true },
		indexes = {
			runtimepath = true,
			gap = 100,
			count = 3,
			projectRootPatterns = { "runtime", "nvim", ".git", "autoload", "plugin" },
		},
		suggest = { fromVimruntime = true, fromRuntimepath = true },
	},
}
