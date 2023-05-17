local M = { "nvim-pack/nvim-spectre" }

M.keys = { { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" } }

return M
