-- local M = "snelling-a/base16.lua"
local M = { "snelling-a/nvim-base16" }

M.cond = not vim.g.vscode

M.dev = true

M.lazy = false

M.priority = 1000

function M.config() vim.cmd.colorscheme("base16-default-dark") end

return M
