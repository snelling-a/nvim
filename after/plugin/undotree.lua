local utils = require("utils")

utils.nmap("<leader>u", vim.cmd.UndotreeToggle)

vim.g.undotree_SetFocusWhenToggle = 1
