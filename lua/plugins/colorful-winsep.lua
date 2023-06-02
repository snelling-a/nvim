local ColorfulWinsep = { "nvim-zh/colorful-winsep.nvim" }

ColorfulWinsep.opts = {
	no_exec_files = {
		"CompetiTest",
		"fzf",
		"mason",
		"noice",
		"nui",
		"NvimTree",
		"packer",
		"TelescopePrompt",
	},
}

ColorfulWinsep.event = { "WinNew" }

return ColorfulWinsep
