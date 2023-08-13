local Firenvim = { "glacambre/firenvim" }

function Firenvim.build()
	require("lazy").load({ plugins = { "firenvim" }, wait = false })
	vim.fn["firenvim#install"](1)
end

function Firenvim.config()
	local api = vim.api
	local g = vim.g
	local opt = vim.opt

	if g.started_by_firenvim then
		opt.colorcolumn = ""
		opt.cursorline = false
		opt.laststatus = 1
		opt.number = false
		opt.relativenumber = false
		opt.showtabline = 0
		opt.spell = true
	end

	g.firenvim_config = {
		globalSettings = { alt = "all" },
		localSettings = {
			[".*"] = { cmdline = "neovim", takeover = "never" },
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
		},
	}

	api.nvim_create_autocmd("BufEnter", {
		callback = function() vim.bo.filetype = "markdown" end,
		desc = "Use markdown formatting for GitHub and reddit",
		group = require("config.util").augroup("Firenvim"),
		pattern = { "*github.com_*", "*reddit.com_*" },
	})
end

return Firenvim
