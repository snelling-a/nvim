local utils = require("utils")

if vim.g.started_by_firenvim then
	utils.opt.colorcolumn = ""
	utils.opt.cursorline = false
	utils.opt.guifont = "Iosevka Nerd Font Mono"
	utils.opt.laststatus = 0
	utils.opt.number = false
	utils.opt.relativenumber = false
	utils.opt.showtabline = 0
	utils.opt.spell = true
end

vim.g.firenvim_config = {
	globalSettings = {
		all = { "<M-t>" },
		alt = "all",
	},
	localSettings = {
		[".*"] = { cmdline = "neovim", filename = "/tmp/{hostname}_{pathname%10}.{extension}" },
		["https?://.*\\.atlassian\\.net/"] = { takeover = "never" },
		["https?://.*\\.regexr\\.com/"] = { takeover = "never" },
		["https?://www.messenger.com"] = { takeover = "never" },
		["https?://docs\\.google\\.com"] = { takeover = "never" },
		["https?://github\\.com/"] = { priority = 1, takeover = "always" },
		["https://mail.proton.me"] = { priority = 1, takeover = "always", selector = 'div[id="rooster-editor"]' },
		["https?://www\\.reddit\\.com/"] = {
			priority = 1,
			takeover = "always",
			selector = 'textarea:not([placeholder*="Title"])',
		},
	},
}

utils.autocmd(
	"BufEnter",
	{ pattern = { "*github.com_*", "*reddit.com_*" }, callback = function() vim.cmd("set filetype=markdown") end }
)
