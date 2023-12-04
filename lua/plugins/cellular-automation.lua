---@type LazySpec
local M = { "eandrju/cellular-automaton.nvim" }

M.cmd = { "CellularAutomaton" }

M.keys = {
	---@diagnostic disable-next-line: missing-fields
	{
		"<leader>fml",
		function()
			require("cellular-automaton").start_animation("make_it_rain")
		end,
		desc = "make it rain",
	},
}

return M
