---@type LazySpec
local M = { "navarasu/onedark.nvim" }

M.enabled = false

-- M.lazy = false

M.opts = { style = "darker" }

-- M.priority = 1000

function M.config(_, opts) -- Lua
	require("onedark").setup(opts)
	require("onedark").load()
end

return M
