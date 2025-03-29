vim.loader.enable()

require("globals")
require("user")

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

local okay, Event = pcall(require, "lazy.core.handler.event")

if not okay then
	vim.notify("Lazy.nvim: " .. vim.inspect(Event), vim.log.levels.ERROR)
end

Event.mappings.LazyFile = { id = "LazyFile", event = { "BufReadPost", "BufNewFile", "BufWritePre" } }
Event.mappings["User LazyFile"] = Event.mappings.LazyFile

require("lazy").setup({
	change_detection = {
		notify = false,
	},
	---@diagnostic disable-next-line: assign-type-mismatch
	dev = { path = "~/dev/github.com/snelling-a/" },
	performance = {
		rtp = {
			disabled_plugins = {
				"gzip",
				"netrwPlugin",
				"rplugin",
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
	spec = {
		{ import = "plugins" },
	},
})
