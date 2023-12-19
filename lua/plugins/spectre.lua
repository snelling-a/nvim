local desc = "[S]earch and [r]eplace with spectre"

---@type LazySpec
local M = { "nvim-pack/nvim-spectre" }

M.keys = { "<leader>sr", desc = desc }

M.opts = { open_cmd = "noswapfile vnew" }

function M.config(_, opts)
	local spectre = require("spectre")
	spectre.setup(opts)

	require("keymap").leader("sr", spectre.open, { desc = desc })
end

return M
