---@type LazySpec
local M = { "lmburns/lf.nvim" }

M.cmd = { "Lf" }

M.dependencies = { "akinsho/toggleterm.nvim" }

M.keys = {
	---@diagnostic disable-next-line: missing-fields
	{ "<M-o>", vim.cmd.Lf, desc = "Open lf" },
}

---@type Lf.Config
M.opts = {
	border = "rounded",
	default_actions = { ["<C-s>"] = "split" },
}

return M
