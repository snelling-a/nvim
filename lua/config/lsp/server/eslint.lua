local M = {}

function M.setup(opts) require("lspconfig").eslint.setup(opts) end

return M
