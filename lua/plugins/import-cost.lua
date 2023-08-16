local ImportCost = {
	"barrett-ruth/import-cost.nvim",
}

ImportCost.build = "sh install.sh yarn"

ImportCost.opts = {
	highlight = "TSComment",
}

ImportCost.ft = vim.fn.deepcopy(require("config.util.constants").javascript_typescript)

ImportCost.config = true

return ImportCost
