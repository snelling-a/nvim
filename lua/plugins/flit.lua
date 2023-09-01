local lables = {
	"s",
	"f",
	"n",
	"u",
	"t",
}

--- @type LazySpec
local M = {
	"ggandor/flit.nvim",
}

M.opts = {
	labeled_modes = "nx",
}

M.dependencies = {
	{
		"tpope/vim-repeat",
		event = "VeryLazy",
	},
	{
		"ggandor/leap.nvim",
		opts = {
			labels = lables,
			safe_labels = lables,
			special_keys = {
				multi_accept = "<enter>",
				multi_revert = "<backspace>",
				next_group = "<space>",
				next_phase_one_target = "<enter>",
				next_target = {
					"<enter>",
					";",
				},
				prev_group = "<tab>",
				prev_target = {
					"<tab>",
					",",
				},
				repeat_search = "<enter>",
			},
		},
		config = function(_, opts)
			local leap = require("leap")
			for k, v in pairs(opts) do
				leap.opts[k] = v
			end
		end,
	},
}

function M.keys()
	local ret = {}
	for _, key in ipairs({
		"f",
		"F",
		"t",
		"T",
	}) do
		ret[#ret + 1] = {
			key,
			mode = {
				"n",
				"o",
				"v",
				"x",
			},
			desc = key,
		}
	end
	return ret
end

return M
