local ImportCost = { "barrett-ruth/import-cost.nvim" }

ImportCost.build = "sh install.sh yarn"

ImportCost.opts = { highlight = "TSComment" }

ImportCost.ft = require("config.util.constants").javascript_typescript

return ImportCost
