local api = vim.api
local g = vim.g

local options = {
	colorcolumn = "",
	cursorline = false,
	guifont = "Iosevka Nerd Font Mono",
	laststatus = 0,
	number = false,
	relativenumber = false,
	showtabline = 0,
	spell = true,
}

if g.started_by_firenvim then
	for option, value in pairs(options) do
		vim.opt[option] = value
	end
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

api.nvim_create_autocmd(
	"BufEnter",
	{ pattern = { "*github.com_*", "*reddit.com_*" }, callback = function() vim.bo.filetype = "markdown" end }
)

api.nvim_create_user_command(
	"FirenvimReload",
	function() vim.fn["firenvim#install"](1) end,
	{ desc = "Reload Firenvim" }
)
