--- @type LazySpec
local M = {
	"nat-418/boole.nvim",
}

local increment = "<C-a>"
local decrement = "<C-x>"

M.event = {
	"BufAdd",
}

M.keys = {
	---@diagnostic disable-next-line: missing-fields
	{
		increment,
		mode = {
			"n",
			"v",
		},
		desc = "Better increment",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		decrement,
		mode = {
			"n",
			"v",
		},
		desc = "Better decrement",
	},
}

M.opts = {
	mappings = {
		increment = increment,
		decrement = decrement,
	},
	additions = {},
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
