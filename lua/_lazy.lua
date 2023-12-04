local lazypath = ("%s/lazy/lazy.nvim"):format(vim.fn.stdpath("data"))
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

---@type LazyConfig
local spec = {
	change_detection = { enabled = true, notify = false },
	checker = { notify = false, enabled = true },
	defaults = { lazy = true, version = false },
	dev = {
		fallback = true,
		path = ("%s/snelling-a"):format(require("util").constants.dev_dir),
		patterns = { "snelling-a" },
	},
	performance = {
		rtp = {
			disabled_plugins = {
				"2html_plugin",
				"getscript",
				"getscriptPlugin",
				"gzip",
				"logipat",
				"netrw",
				"netrwFileHandlers",
				"netrwPlugin",
				"netrwSettings",
				"rplugin",
				"rrhelper",
				"shada",
				"spellfile",
				"spellfile_plugin",
				"tar",
				"tarPlugin",
				"tohtml",
				"tutor",
				"vimball",
				"vimballPlugin",
				"zip",
				"zipPlugin",
				-- "matchit",
				-- "matchparen",
			},
		},
	},
	spec = {
		{ import = "plugins" },
	},
	ui = {
		border = "rounded",
		icons = require("ui.icons").lazy,
	},
}

require("lazy").setup(spec)
