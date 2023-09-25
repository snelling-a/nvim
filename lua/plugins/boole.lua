--- @type LazySpec
local M = {
	"nat-418/boole.nvim",
}

M.event = require("config.util.constants").lazy_event

M.opts = {
	mappings = {
		increment = "<C-a>",
		decrement = "<C-x>",
	},
	allow_caps_additions = {
		{
			"foo",
			"bar",
		},
		{
			"enable",
			"disable",
		},
	},
}

return M
