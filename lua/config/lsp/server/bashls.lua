local M = {}

M.mason_name = "bash-language-server"

--- @param opts lspconfig.Config
function M.setup(opts) require("lspconfig").bashls.setup(opts) end

return M
