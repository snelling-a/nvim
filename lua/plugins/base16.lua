local M = { "snelling-a/base16.nvim" }
-- local M = { "RRethy/nvim-base16" }

M.dev = true

M.lazy = false

M.priority = 1000

function M.config() vim.cmd.colorscheme("base16-default-dark") end

return M
