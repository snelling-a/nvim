local lspconfig = require("lspconfig")

local M = {}

function M.setup(opts) lspconfig.marksman.setup(opts) end

return M
