--- @type LazySpec
local M = {
	"eandrju/cellular-automaton.nvim",
}

M.keys = {
	---@diagnostic disable-next-line: missing-fields
	{
		"<leader>fml",
		function() vim.cmd.CellularAutomaton("make_it_rain") end,
		desc = "make it rain",
	},
}

return M
