---@type LazySpec
local M = { "rebelot/kanagawa.nvim" }

M.cmd = { "KanagawaCompile" }

-- M.lazy = false

---@type KanagawaConfig
M.opts = {
	background = { dark = "dragon" },
	compile = true,
	dimInactive = true,
	theme = "dragon",
}

-- M.priority = 1000

function M.config(_, opts)
	require("kanagawa").setup(opts)
end

return M
