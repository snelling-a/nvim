---@type LazySpec
local M = { "snelling-a/base16.nvim" }

M.cond = not vim.g.vscode

M.dev = true

M.lazy = false

M.priority = 1000

return M
