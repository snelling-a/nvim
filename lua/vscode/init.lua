local opt = require("utils").opt

local options = {
	completeopt = "menuone,noselect",
	hidden = true,
	ignorecase = true,
	inccommand = "split",
	mouse = "a",
	pumheight = 10,
	relativenumber = true,
	scrolloff = 8,
	shiftwidth = 2,
	showmode = false,
	showtabline = 2,
	smartcase = true,
	smartindent = true,
	splitbelow = true,
	splitright = true,
	tabstop = 2,
	updatetime = 300,
	wildmode = "list:longest",
}

for option, value in pairs(options) do
	opt[option] = value
end

vim.g.mapleader = ","
vim.g.maplocalleader = ","
