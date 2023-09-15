--- @type LazySpec
local M = {
	"navarasu/onedark.nvim",
}

M.cmd = "GenerateAverageColor"

-- M.lazy = false

M.opts = {
	style = "darker",
}

-- M.priority = 1000

function M.config(_, opts) -- Lua
	require("onedark").setup(opts)
	require("onedark").load()

	-- vim.cmd.colorscheme("onedark")
end

return M
