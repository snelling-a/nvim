local M = { "eandrju/cellular-automaton.nvim" }

M.keys = { { "<leader>fml", function() vim.cmd.CellularAutomaton("make_it_rain") end, desc = "make it rain" } }

return M
