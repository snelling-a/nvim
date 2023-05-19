local icons = require("config.ui.icons")

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
	change_detection = { notify = false },
	dev = { path = os.getenv("HOME") .. "/dev/github.com/snelling-a" },
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				"rplugin",
				"spellfile",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
	spec = { import = "plugins" },
	ui = {
		border = "rounded",
		icons = {
			cmd = icons.cmp.cmd,
			config = icons.misc.gears,
			event = icons.kind_icons.Event,
			ft = icons.file.buffer,
			init = icons.misc.rocket,
			import = icons.file.import,
			keys = icons.misc.keyboard,
			loaded = icons.progress.done,
			not_loaded = icons.progress.pending,
			plugin = icons.kind_icons.Package,
			runtime = icons.misc.code,
			source = icons.file.folder_open,
			start = icons.misc.right,
			task = icons.misc.checklist,
			list = {
				icons.misc.selection,
				icons.misc.chevron_right,
				"‒",
				icons.listchars.trail,
			},
		},
	},
})
