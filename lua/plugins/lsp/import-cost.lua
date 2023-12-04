--- @type LazySpec
local M = { "barrett-ruth/import-cost.nvim" }

M.build = "sh install.sh yarn"

M.config = true

M.ft = require("util.constants").javascript_typescript

M.opts = { highlight = "TSComment" }

return M
