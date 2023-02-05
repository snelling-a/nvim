local utils = require("utils")
local zen_mode = require("zen-mode")

zen_mode.setup({
	window = {
		width = 100,
		options = {
			number = true,
			relativenumber = true,
		},
	},
})

utils.nmap("<leader>zz", function()
	zen_mode.toggle()
	vim.wo.wrap = false
end)
