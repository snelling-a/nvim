--- @type LazySpec
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
	---@diagnostic disable-next-line: missing-fields
	{
		"<leader>sn",
		function() require("scretch").new() end,
		desc = "[N]ew [s]cretch",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"<leader>snn",
		function() require("scretch").new_named() end,
		desc = "[N]ew [s]cretch [n]amed",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"<leader>sl",
		function() require("scretch").last() end,
		desc = "[L]ast [s]cretch",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"<leader>ss",
		function() require("scretch").search() end,
		desc = "[S]cretch [S]earch",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"<leader>sg",
		function() require("scretch").grep() end,
		desc = "[G]rep [S]cretch",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"<leader>sv",
		function() require("scretch").explore() end,
		desc = "Open [S]cretch dir in file Explorer",
	},
}

return M
