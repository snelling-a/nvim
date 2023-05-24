local M = { "barrett-ruth/import-cost.nvim" }

M.build = "sh install.sh yarn"

M.opts = { highlight = "TSComment" }

M.ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" }

return M
