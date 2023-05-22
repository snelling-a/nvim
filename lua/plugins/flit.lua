local M = { "ggandor/flit.nvim" }

M.opts = { labeled_modes = "nx" }

M.dependencies = {
	"tpope/vim-repeat",
	{
		"ggandor/leap.nvim",
		-- keys = {
		-- 	{ "s", mode = { "n", "x", "o" }, desc = "Leap forward to" },
		-- 	{ "S", mode = { "n", "x", }, desc = "Leap backward to" },
		-- 	{ "gs", mode = { "n", "x", "o" }, desc = "Leap from windows" },
		-- },
		opts = {
			safe_labels = { "f", "n", "u", "t" },
			labels = { "f", "n", "j", "k" },
			special_keys = {
				repeat_search = "<enter>",
				next_phase_one_target = "<enter>",
				next_target = { "<enter>", ";" },
				prev_target = { "<tab>", "," },
				next_group = "<space>",
				prev_group = "<tab>",
				multi_accept = "<enter>",
				multi_revert = "<backspace>",
			},
		},
		config = function(_, opts)
			local leap = require("leap")
			for k, v in pairs(opts) do
				leap.opts[k] = v
			end
			-- leap.add_default_mappings(true)
			-- vim.keymap.del({ "x", "o" }, "x")
			-- vim.keymap.del({ "x", "o" }, "X")
		end,
	},
}

function M.keys()
	local ret = {}
	for _, key in ipairs({ "f", "F", "t", "T" }) do
		ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
	end
	return ret
end

return M
