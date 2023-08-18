local Spectre = {
	"nvim-pack/nvim-spectre",
}

Spectre.keys = {
	{
		"<leader>sr",
		function() require("spectre").open() end,
		desc = "[S]pectre [R]eplace",
	},
}

return Spectre
