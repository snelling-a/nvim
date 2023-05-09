local icons = require("config.ui.icons")

local is_obsidian = require("config.util").obsidian.is_vault_directory

---comment
---@param text? string @The text to display in the logo; defaults to "neovim"
---@return _ string @The header for alpha
local function get_header(text)
	return " ▌║█║▌│║▌│║▌║▌█║ "
		.. (text or "neovim")
		.. " ▌│║▌║▌│║║▌█║▌║█ "
end

local quit_button = { shortcut = "q", val = icons.misc.exit .. " Quit", on_press = ":qa<CR>" }

local default_buttons = {
	{ shortcut = "p", val = icons.misc.search .. " Find file", on_press = [[:lua require("fzf-lua").files() <CR>]] },
	{ shortcut = "n", val = icons.file.newfile .. " New file", on_press = ":ene <BAR> startinsert <CR>" },
	{
		shortcut = "o",
		val = icons.misc.files .. " Recent files",
		on_press = [[:lua require("fzf-lua").oldfiles() <CR>]],
	},
	{
		shortcut = "r",
		val = icons.misc.search_text .. " Find text",
		on_press = [[:lua require("fzf-lua").live_grep() <CR>]],
	},
	{
		shortcut = "s",
		val = icons.misc.restore .. " Restore Session",
		on_press = [[:lua require("config.session").load_session() <cr>]],
	},
	{ shortcut = "l", val = icons.misc.lazy .. " Lazy", on_press = [[:lua vim.cmd.Lazy("update") <CR>]] },
	{ shortcut = "m", val = icons.misc.tools .. " Mason", on_press = [[:lua vim.cmd.Mason() <CR>]] },
	{ shortcut = "c", val = icons.misc.health .. " Check health", on_press = [[:lua vim.cmd.checkhealth() <CR>]] },
	quit_button,
}

local obsidian_buttons = {
	{
		shortcut = "d",
		val = icons.obsidian.today .. " Today's daily note",
		on_press = [[:lua vim.cmd.ObsidianToday() <CR>]],
	},
	{
		shortcut = "y",
		val = icons.obsidian.yesterday .. " Yesterday's daily note",
		on_press = [[:lua vim.cmd.ObsidianYesterday() <CR>]],
	},
	{
		shortcut = "n",
		val = icons.obsidian.new .. " New note",
		on_press = [[:lua vim.cmd.ObsidianNew() <CR>]],
	},
	{
		shortcut = "s",
		val = icons.obsidian.search .. " Search vault",
		on_press = [[:lua vim.cmd.ObsidianSearch() <CR>]],
	},
	{
		shortcut = "c",
		val = icons.obsidian.health .. " Check health",
		on_press = [[:lua vim.cmd.ObsidianCheckHealth() <CR>]],
	},
	quit_button,
}

local M = { "goolord/alpha-nvim" }

M.event = "VimEnter"

function M.config(_, dashboard)
	if vim.o.filetype == "lazy" then
		vim.cmd.close()
		vim.api.nvim_create_autocmd("User", {
			pattern = "AlphaReady",
			callback = function() require("lazy").show() end,
		})
	end

	require("alpha").setup(dashboard.config)

	vim.api.nvim_create_autocmd("User", {
		pattern = "LazyVimStarted",
		callback = function()
			local version = " " .. vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch
			local stats = require("lazy").stats()
			local startup_time = (math.floor(stats.startuptime * 100 + 0.5) / 100)
			local total_plugins = stats.count .. " Plugins"
			dashboard.section.footer.val = version .. "   " .. total_plugins .. "  󰄉 " .. startup_time .. " ms"
			pcall(vim.cmd.AlphaRedraw)
		end,
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
		if is_obsidian then
			return { header = get_header("obsidian"), buttons = get_buttons(obsidian_buttons) }
		else
			return { header = get_header(), buttons = get_buttons() }
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
