---@type LazySpec
local M = { "nvim-pack/nvim-spectre" }

M.cmd = { "Spectre" }

M.keys = {
	{
		"<leader>sr",
		function()
			require("spectre").open()
		end,
		desc = "[S]earch and [r]eplace with spectre",
	},
}

M.opts = { open_cmd = "noswapfile vnew" }

return M
