local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
	local Logger = require("config.util.logger"):new("Lazy")
	Logger:info("Installing Lazy.nvim")

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

---@type LazyConfig
local opts = {
	change_detection = {
		notify = false,
	},
	dev = {
		fallback = true,
		path = require("config.util.constants").dev_dir .. "/snelling-a",
		patterns = {
			"snelling-a",
		},
	},
	install = {
		colorscheme = {
			"average-dark",
			"base16-default-dark",
			"habamax",
		},
	},
	lazy = true,
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"netrwPlugin",
				"rplugin",
				"spellfile",
				"shada",
				"tarPlugin",
				-- "tohtml",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
	spec = {
		import = "plugins",
	},
	ui = {
		border = "rounded",
		icons = require("config.ui.icons").lazy,
	},
}

require("lazy").setup(opts)
