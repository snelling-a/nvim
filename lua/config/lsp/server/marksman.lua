local M = {}

--- @param opts lspconfig.Config
function M.setup(opts) require("lspconfig").marksman.setup(opts) end

return M
