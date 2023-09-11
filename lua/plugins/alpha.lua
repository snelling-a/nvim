local Icons = require("config.ui.icons")
local Util = require("config.util")

local buttons = {
	{
		shortcut = "p",
		val = Util.pad_right(Icons.misc.search) .. "Find file",
		on_press = [[:lua require("fzf-lua").files() <CR>]],
	},
	{
		shortcut = "n",
		val = Util.pad_right(Icons.file.newfile) .. "New file",
		on_press = ":ene <BAR> startinsert <CR>",
	},
	{
		shortcut = "o",
		val = Util.pad_right(Icons.misc.files) .. "Recent files",
		on_press = [[:lua require("fzf-lua").oldfiles() <CR>]],
	},
	{
		shortcut = "r",
		val = Util.pad_right(Icons.misc.search_text) .. "Find text",
		on_press = [[:lua require("fzf-lua").live_grep() <CR>]],
	},
	{
		shortcut = "s",
		val = Util.pad_right(Icons.misc.restore) .. "Restore Session",
		on_press = [[:lua require("config.session").load_session() <cr>]],
	},
	{
		shortcut = "h",
		val = Util.pad_right(Icons.misc.help) .. "Help",
		on_press = [[:lua require("fzf-lua").help_tags() <CR>]],
	},
	{
		shortcut = "l",
		val = Util.pad_right(Icons.misc.lazy) .. "Lazy",
		on_press = [[:lua vim.cmd.Lazy("update") <CR>]],
	},
	{
		shortcut = "m",
		val = Util.pad_right(Icons.misc.tools) .. "Mason",
		on_press = [[:lua vim.cmd.Mason() <CR>]],
	},
	{
		shortcut = "c",
		val = Util.pad_right(Icons.misc.health) .. "Check health",
		on_press = [[:lua vim.cmd.checkhealth() <CR>]],
	},
	{
		shortcut = "q",
		val = Util.pad_right(Icons.misc.exit) .. "Quit",
		on_press = ":qa<CR>",
	},
}

--- @type LazySpec
local M = {
	"goolord/alpha-nvim",
}

M.cond = not vim.g.started_by_firenvim

M.event = "VimEnter"

function M.config(_, dashboard)
	local augroup = Util.augroup

	if vim.o.filetype == "lazy" then
		vim.cmd.close()
		vim.api.nvim_create_autocmd("User", {
			callback = function() require("lazy").show() end,
			desc = "Show Lazy",
			group = augroup("ShowLazy"),
			pattern = "AlphaReady",
		})
	end

	require("alpha").setup(dashboard.config)

	vim.api.nvim_create_autocmd("User", {
		callback = function()
			local stats = require("lazy").stats()
			local v = vim.version()

			local version = string.format("%s %d.%d.%d", Icons.misc.version, v.major, v.minor, v.patch)

			local time = (math.floor(stats.startuptime * 100 + 0.5) / 100)
			local startup_time = string.format("%s %d ms", Icons.progress.pending, time)

			local plugins = string.format("%s %d Plugins", Icons.misc.rocket, stats.count)

			dashboard.section.footer.val = string.format("%s %s %s", version, plugins, startup_time)
			vim.opt_local.statusline = " "
			pcall(vim.cmd.AlphaRedraw)
		end,
		desc = "Render alpha footer",
		group = augroup("AlphaFooter"),
		pattern = "LazyVimStarted",
	})
end

function M.opts()
	local dashboard = require("alpha.themes.dashboard")

	local function get_buttons()
		return vim.tbl_map(function(b)
			local button = dashboard.button(b.shortcut, b.val, b.on_press)

			button.opts.hl = "AlphaButtons"
			button.opts.hl_shortcut = "AlphaShortcut"

			return button
		end, buttons)
	end

	local content = {
		header = " ▌║█║▌│║▌│║▌║▌█║  neovim  ▌│║▌║▌│║║▌█║▌║█ ",
		buttons = get_buttons(),
	}

	dashboard.section.header.val = content.header

	dashboard.section.buttons.val = content.buttons

	dashboard.section.header.opts.hl = "AlphaHeader"
	dashboard.section.buttons.opts.hl = "AlphaButtons"
	dashboard.section.footer.opts.hl = "AlphaFooter"
	dashboard.opts.layout[1].val = 8

	return dashboard
end

M.enabled = false
return M
