local M = {}

function M.setup(opts) require("lspconfig").bashls.setup(opts) end

return M
