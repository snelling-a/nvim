---@type LazySpec
local M = { "ggandor/leap.nvim" }

M.dependencies = {
	{ "tpope/vim-repeat", event = require("util").constants.lazy_event },
}

M.keys = {
	{
		"s",
		mode = { "n", "x", "o" },
		desc = "Leap forward to",
	},
	{
		"S",
		mode = { "n", "x", "o" },
		desc = "Leap backward to",
	},
}

function M.config(_, opts)
	local leap = require("leap")
	for k, v in pairs(opts) do
		leap.opts[k] = v
	end
	leap.add_default_mappings(true)
	vim.keymap.del({ "x", "o" }, "x")
	vim.keymap.del({ "x", "o" }, "X")
end

return M
