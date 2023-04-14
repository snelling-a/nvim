local api = vim.api
local g = vim.g
local opt = vim.opt

if g.started_by_firenvim then
	opt.colorcolumn = ""
	opt.cursorline = false
	opt.guifont = "Iosevka Nerd Font Mono"
	opt.laststatus = 1
	opt.number = false
	opt.relativenumber = false
	opt.showtabline = 0
	opt.spell = true
end

local global_settings = {
	all = { "<M-t>" },
	alt = "all",
}

local local_settings = {
	[".*"] = { cmdline = "neovim", filename = "/tmp/{hostname}_{pathname%10}.{extension}" },
	["https?://.*\\.atlassian\\.net/"] = { takeover = "never" },
	["https?://.*\\.regexr\\.com/"] = { takeover = "never" },
	["https?://www.messenger.com"] = { takeover = "never" },
	["https?://docs\\.google\\.com"] = { takeover = "never" },
	["https?://github\\.com/"] = {
		priority = 1,
		takeover = "always",
		selector = "textarea:not(#read-only-cursor-text-area)",
	},
	["https://mail.proton.me"] = { priority = 1, takeover = "always", selector = 'div[id="rooster-editor"]' },
	["https?://www\\.reddit\\.com/"] = {
		priority = 1,
		takeover = "always",
		selector = 'textarea:not([placeholder*="Title"])',
	},
}

g.firenvim_config = {
	globalSettings = global_settings,
	localSettings = local_settings,
}

api.nvim_create_autocmd("BufEnter", {
	callback = function() vim.bo.filetype = "markdown" end,
	desc = "Use markdown formatting for GitHub and reddit",
	group = api.nvim_create_augroup("Firenvim", {}),
	pattern = { "*github.com_*", "*reddit.com_*" },
})

api.nvim_create_user_command(
	"FirenvimReload",
	function() vim.fn["firenvim#install"](1) end,
	{ desc = "Reload Firenvim" }
)
