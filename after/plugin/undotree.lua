local utils = require("utils")

utils.nmap("<leader>u", vim.cmd.UndotreeToggle, { desc = "Toggle undotree" })

vim.g.undotree_SetFocusWhenToggle = 1
