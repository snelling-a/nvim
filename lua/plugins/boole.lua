---@type LazySpec
local M = { "nat-418/boole.nvim" }

M.keys = {
	{ "<C-a>", desc = "Boole increment" },
	{ "<C-x>", desc = "Boolen decrement" },
}

M.opts = {
	mappings = {
		increment = "<C-a>",
		decrement = "<C-x>",
	},
	allow_caps_additions = {
		{ "const", "let" },
		{ "enable", "disable" },
		{ "foo", "bar" },
		{ "left", "right" },
		{ "previous", "next" },
	},
}

return M
