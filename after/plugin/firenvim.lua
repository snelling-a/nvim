local utils = require("utils")

if vim.g.started_by_firenvim then
	vim.opt.colorcolumn = ""
	vim.opt.cursorline = false
	vim.opt.guifont = "Iosevka Nerd Font Mono"
	vim.opt.laststatus = 0
	vim.opt.number = false
	vim.opt.relativenumber = false
	vim.opt.showtabline = 0
	vim.opt.spell = true
end

vim.g.firenvim_config = {
	globalSettings = { alt = "all" },
	localSettings = {
		["https?://www.reddit.com/"] = {
			priority = 1,
			takeover = "always",
			selector = 'textarea:not([placeholder*="Title"])',
		},
		["https?://github.com/"] = {
			priority = 1,
			takeover = "always",
		},
		[".*"] = {
			takeover = "never",
			cmdline = "neovim",
			filename = "/tmp/{hostname}_{pathname%10}.{extension}",
		},
	},
}

utils.autocmd("BufEnter", {
	pattern = { "*github.com_*", "*reddit.com_*" },
	callback = function() vim.cmd("set filetype=markdown") end,
})
