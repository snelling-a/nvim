if vim.fn.has("nvim-0.9.0") == 0 then
	vim.api.nvim_echo({
		{ "Neovim version >= 0.9.0 required\n", "ErrorMsg" },
		{ "Press any key to exit", "MoreMsg" },
	}, true, {})
	vim.fn.getchar()
	vim.cmd([[quit]])
	return {}
end

if vim.fn.has("nvim-0.10.0") == 0 then
	vim.api.nvim_echo({
		{ "Neovim version >= 0.10.0 recommended\nCompatabiliy should be in place\n", "WarningMsg" },
		{ "You have been warned\n", "WarningMsg" },
		{ "Press any key to continue", "MoreMsg" },
	}, true, {})
end

require("config").setup()
