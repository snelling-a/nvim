local M = {}

M.mason_name = "awk-language-server"

--- @param opts lspconfig.Config
function M.setup(opts) require("lspconfig").awk_ls.setup(opts) end

return M
