local M = {}

function M.setup(opts) require("lspconfig").sqlls.setup(opts) end

return M
