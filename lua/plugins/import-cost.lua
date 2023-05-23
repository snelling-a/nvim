local M = { "barrett-ruth/import-cost.nvim" }

M.build = "sh install.sh yarn"

M.opts = { highlight = "TSComment" }

M.filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" }

return M
