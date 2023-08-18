local CellularAutomation = {
	"eandrju/cellular-automaton.nvim",
}

CellularAutomation.lazy = true

CellularAutomation.keys = {
	{
		"<leader>fml",
		function() vim.cmd.CellularAutomaton("make_it_rain") end,
		desc = "make it rain",
	},
}

return CellularAutomation
