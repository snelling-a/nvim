--- @type LazySpec
local M = {
	"David-Kunz/jester",
}

M.enabled = false

M.keys = {
	---@diagnostic disable-next-line: missing-fields
	{
		"<leader>djt",
		function() require("jester").debug() end,
		desc = "DAP Jester debug test",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"<leader>djf",
		function() require("jester").debug_file() end,
		desc = "DAP Jester debug file",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"<leader>djr",
		function() require("jester").debug_last() end,
		desc = "DAP Jester rerun debug",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"<leader>djT",
		function() require("jester").run() end,
		desc = "DAP Jester run test",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"<leader>djF",
		function() require("jester").run_file() end,
		desc = "DAP Jester run file",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"<leader>djR",
		function() require("jester").run_last() end,
		desc = "DAP Jester rerun test",
	},
}

M.opts = {
	cmd = "nmp run test --testNamePattern '$result' -- $file", -- run command
	terminal_cmd = "ToggleTerm",
}

return M
