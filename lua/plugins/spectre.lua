local M = {
	"nvim-pack/nvim-spectre",
}

M.keys = {
	{
		"<leader>sr",
		function() require("spectre").open() end,
		desc = "[S]pectre [R]eplace",
	},
}

return M
