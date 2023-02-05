local utils = require("utils")
local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

utils.nmap("<leader>a", mark.add_file)
utils.nmap("<C-e>", ui.toggle_quick_menu)

utils.nmap("<C-1>", function() ui.nav_file(1) end)
utils.nmap("<C-2>", function() ui.nav_file(2) end)
utils.nmap("<C-3>", function() ui.nav_file(3) end)
utils.nmap("<C-4>", function() ui.nav_file(4) end)
