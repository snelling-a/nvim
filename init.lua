vim.loader.enable()

require("globals")
Config.setup()

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

---@type LazyConfig
local spec = {
	spec = {
		{ import = "plugins" },
	},
	dev = { path = "~/dev/github.com/snelling-a/" },
	change_detection = { enabled = true, notify = false },
	checker = { enabled = true, notify = false },
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
				-- "matchit",
				-- "matchparen",
			},
			reset = false,
		},
	},
	profiling = { loader = true, require = true },
	ui = { border = "rounded" },
}

local okay, Event = pcall(require, "lazy.core.handler.event")
if not okay then
	vim.notify("Lazy.nvim: " .. Event, vim.log.levels.ERROR)
end
Event.mappings.LazyFile = { id = "LazyFile", event = { "BufReadPost", "BufNewFile", "BufWritePre" } }
Event.mappings["User LazyFile"] = Event.mappings.LazyFile

require("lazy").setup(spec)
