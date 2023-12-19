local desc = "make it rain"
---@type LazySpec
local M = { "eandrju/cellular-automaton.nvim" }


M.keys = { "<leader>fml", desc = desc }

function M.config(_, opts)
	local ca = require("cellular-automaton")
	ca.setup(opts)

	require("keymap").leader("fml", function()
		ca.start_animation("make_it_rain")
	end, { desc = desc })
end

return M
