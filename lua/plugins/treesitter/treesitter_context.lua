---@type LazySpec
local M = { "nvim-treesitter/nvim-treesitter-context" }

M.event = require("util").constants.lazy_event

M.opts = { mode = "cursor" }

function M.config(_, opts)
	local ts_context = require("treesitter-context")
	ts_context.setup(opts)

	local Keymap = require("keymap")

	Keymap.nmap("[x", ts_context.go_to_context, { silent = true, desc = "Go to conte[x]t " })
	Keymap.leader("ut", function()
		local logger = require("util.logger"):new("Treesitter")
		local Util = require("util")
		ts_context.toggle()
		if Util.get_upvalue(ts_context.toggle, "enabled") then
			logger:info("Enabled Treesitter Context")
		else
			logger:warn("Disabled Treesitter Context")
		end
	end, { desc = "Toggle Treesitter Context" })
end

return M
