local Icons = require("config.ui.icons")
local Util = require("config.util")

--- @param text? string 'The text to display in the logo; defaults to "neovim"'
--- @return string 'The header for alpha'
local function get_header(text)
	return " ▌║█║▌│║▌│║▌║▌█║ "
		.. (text or "neovim")
		.. " ▌│║▌║▌│║║▌█║▌║█ "
end

local quit_button = {
	shortcut = "q",
	val = Util.pad_right(Icons.misc.exit) .. "Quit",
	on_press = ":qa<CR>",
}

local default_buttons = {
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
	quit_button,
}

local obsidian_buttons = {
	{
		shortcut = "d",
		val = Util.pad_right(Icons.obsidian.today) .. "Today's daily note",
		on_press = [[:lua vim.cmd.ObsidianToday() <CR>]],
	},
	{
		shortcut = "y",
		val = Util.pad_right(Icons.obsidian.yesterday) .. "Yesterday's daily note",
		on_press = [[:lua vim.cmd.ObsidianYesterday() <CR>]],
	},
	{
		shortcut = "n",
		val = Util.pad_right(Icons.obsidian.new) .. "New note",
		on_press = [[:lua vim.cmd.ObsidianNew() <CR>]],
	},
	{
		shortcut = "s",
		val = Util.pad_right(Icons.obsidian.search) .. "Search vault",
		on_press = [[:lua vim.cmd.ObsidianSearch() <CR>]],
	},
	{
		shortcut = "c",
		val = Util.pad_right(Icons.obsidian.health) .. "Check health",
		on_press = [[:lua vim.cmd.ObsidianCheckHealth() <CR>]],
	},
	quit_button,
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

	local function get_buttons(button_set)
		return vim.tbl_map(function(b)
			local button = dashboard.button(b.shortcut, b.val, b.on_press)

			button.opts.hl = "AlphaButtons"
			button.opts.hl_shortcut = "AlphaShortcut"

			return button
		end, button_set or default_buttons)
	end

	local function get_content()
		if require("config.util.constants").obsidian.is_vault_directory then
			return {
				header = get_header("obsidian"),
				buttons = get_buttons(obsidian_buttons),
			}
		else
			return {
				header = get_header(),
				buttons = get_buttons(),
			}
		end
	end

	local content = get_content()

	dashboard.section.header.val = content.header

	dashboard.section.buttons.val = content.buttons

	dashboard.section.header.opts.hl = "AlphaHeader"
	dashboard.section.buttons.opts.hl = "AlphaButtons"
	dashboard.section.footer.opts.hl = "AlphaFooter"
	dashboard.opts.layout[1].val = 8

	return dashboard
end

return M
