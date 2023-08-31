local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	change_detection = {
		notify = false,
	},
	dev = {
		fallback = true,
		path = require("config.util.constants").dev_dir .. "/snelling-a",
	},
	install = {
		colorscheme = {
			"average-dark",
			"base16-default-dark",
			"habamax",
		},
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				-- "matchit",
				"netrwPlugin",
				"rplugin",
				"spellfile",
				"tarPlugin",
				-- "tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
	spec = {
		import = "plugins",
	},
	ui = require("config.ui.icons").lazy,
})
