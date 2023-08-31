local M = {
	"barrett-ruth/import-cost.nvim",
}

M.build = "sh install.sh yarn"

M.opts = {
	highlight = "TSComment",
}

M.ft = require("config.util.constants").javascript_typescript

M.config = true

return M
