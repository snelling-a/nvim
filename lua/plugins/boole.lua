--- @type LazySpec
local M = {
	"nat-418/boole.nvim",
}

M.keys = {
	{
		"<C-a>",
		mode = {
			"n",
			"v",
		},
	},
	{
		"<C-x>",
		mode = {
			"n",
			"v",
		},
		desc = "Better decrement",
	},
}

M.opts = {
	mappings = {
		increment = "<C-a>",
		decrement = "<C-x>",
	},
	additions = {
		{
			"Foo",
			"Bar",
		},
		{
			"tic",
			"tac",
			"toe",
		},
	},
	allow_caps_additions = {
		{
			"enable",
			"disable",
		},
	},
}

return M
