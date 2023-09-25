local M = {}

--- @param opts lspconfig.Config
function M.setup(opts) require("lspconfig").sqlls.setup(opts) end

return M
