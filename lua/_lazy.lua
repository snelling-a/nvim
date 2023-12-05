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
		{ import = "plugins.colorscheme" },
		{ import = "plugins.completion" },
		{ import = "plugins.git" },
		{ import = "plugins.lsp" },
		{ import = "plugins.treesitter" },
	},
	ui = {
		border = "rounded",
		icons = require("ui.icons").lazy,
	},
}

require("lazy").setup(spec)

local Config = require("lazy.core.config")
local M = {}

--- Check if plugin is available
---@param plugin string name of plugin
---@return boolean loaded if plugin is loaded
function M.has_plugin(plugin)
	return Config.spec.plugins[plugin] ~= nil
end

---@param name string
function M.get_opts(name)
	local plugin = Config.plugins[name]
	if not plugin then
		return {}
	end
	local Plugin = require("lazy.core.plugin")
	return Plugin.values(plugin, "opts", false)
end

return M
