local M = { "mbbill/undotree" }

M.cmd = "UndotreeToggle"

M.keys = { { "<leader>u", vim.cmd.UndotreeToggle, desc = "Toggle [u]ndotree" } }

function M.config() vim.api.nvim_set_var("undotree_SetFocusWhenToggle", 1) end

return M
