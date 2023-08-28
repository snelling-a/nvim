local M = {}

M.mason_name = "awk-language-server"

function M.setup(opts) require("lspconfig").awk_ls.setup(opts) end

return M
