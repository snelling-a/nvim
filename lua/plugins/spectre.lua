--- @type LazySpec
local M = {
	"nvim-pack/nvim-spectre",
}

M.keys = {
	---@diagnostic disable-next-line: missing-fields
	{
		"<leader>sr",
		function() require("spectre").open() end,
		desc = "[S]pectre [R]eplace",
	},
}

return M
