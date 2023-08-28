local M = {
	"Sonicfury/scretch.nvim",
}

M.dependencies = {
	"ibhagwan/fzf-lua",
}

M.opts = {
	backend = "fzf-lua",
	scretch_dir = vim.fn.stdpath("cache") .. "/scretch/",
}

M.keys = {
	{
		"<leader>sn",
		function() require("scretch").new() end,
		desc = "[N]ew [s]cretch",
	},
	{
		"<leader>snn",
		function() require("scretch").new_named() end,
		desc = "[N]ew [s]cretch [n]amed",
	},
	{
		"<leader>sl",
		function() require("scretch").last() end,
		desc = "[L]ast [s]cretch",
	},
	{
		"<leader>ss",
		function() require("scretch").search() end,
		desc = "[S]cretch [S]earch",
	},
	{
		"<leader>sg",
		function() require("scretch").grep() end,
		desc = "[G]rep [S]cretch",
	},
	{
		"<leader>sv",
		function() require("scretch").explore() end,
		desc = "Open [S]cretch dir in file Explorer",
	},
}

return M
