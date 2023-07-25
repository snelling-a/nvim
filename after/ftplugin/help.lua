vim.treesitter.start()

local opt = vim.opt_local

opt.number = true
opt.numberwidth = 1
opt.relativenumber = true

opt.statuscolumn = [[%#NonText#%{&nu?(&rnu&&v:relnum?v:relnum:v:lnum):''}%=]]
	.. require("config.ui.icons").fillchars.foldsep
	.. "%T"
