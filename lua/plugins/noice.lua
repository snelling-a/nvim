local icons = require("config.ui.icons")
local util = require("config.util")

local function get_search(icon) return icons.misc.search .. icon end

local cmdline = {
	-- view = "cmdline",
	format = {
		cmdline = { icon = util.pad_right(icons.languages.vim), lang = "vim", pattern = "^:" },
		filter = { icon = util.pad_right(icons.languages.bash), lang = "bash", pattern = "^:%s*!" },
		input = { lang = "vim" },
		lua = {
			icon = util.pad_right(icons.languages.lua),
			lang = "lua",
			pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" },
		},
		help = { icon = util.pad_right(icons.misc.help), pattern = "^:%s*he?l?p?%s+" },
		search_down = { icon = get_search(icons.misc.chevron_down), kind = "search", lang = "regex", pattern = "^/" },
		search_up = { icon = get_search(icons.misc.chevron_up), kind = "search", lang = "regex", pattern = "^%?" },
	},
}

local lsp_progress_format = {
	{ "[{data.progress.percentage}%] ", hl_group = "NoiceLspProgressTitle" },
	{ "{spinner} ", hl_group = "NoiceLspProgressSpinner" },
	{ "[{data.progress.title}] ", hl_group = "NoiceLspProgressTitle" },
}

local routes = {
	{ view = "split", filter = { event = "msg_show", min_height = 10 } },
	{
		filter = {
			any = {
				{ event = "msg_show", kind = "emsg", find = "E382" }, -- Cannot write, 'buftype' option is set
				{ event = "msg_show", kind = "lua_error", find = "E5108" }, -- CellularAutomation error if folds in file
				{ event = "notify", kind = "warn", find = "Already attached" }, -- navic preferences don't work with 3 servers
			},
		},
		opts = { skip = true },
	},
}

local M = { "folke/noice.nvim" }

M.cond = util.is_vim()

M.dependencies = {
	"MunifTanjim/nui.nvim",
	{
		"rcarriga/nvim-notify",
		keys = {
			{
				"<leader>un",
				function() require("notify").dismiss({ silent = true, pending = true }) end,
				desc = "Dismiss all Notifications",
			},
		},
		opts = {
			timeout = 3000,
			max_height = function() return math.floor(vim.o.lines * 0.5) end,
			max_width = function() return math.floor(vim.o.columns * 0.75) end,
		},
		init = function()
			if not util.has("noice") then
				vim.opt.termguicolors = true
				vim.notify = require("notify")
			end
		end,
	},
}

M.opts = {
	cmdline = cmdline,
	commands = {},
	lsp = {
		override = {
			["cmp.entry.get_documentation"] = true,
			["vim.lsp.util.convert_input_to_markdown_lines"] = true,
			["vim.lsp.util.stylize_markdown"] = true,
		},
		progress = { format = lsp_progress_format },
		signature = { enabled = false },
	},
	messages = { view = "mini", view_error = "mini", view_warn = "mini", view_search = false },
	notify = { view = "mini" },
	popupmenu = { enabled = true, backend = "cmp", kind_icons = icons.kind_icons },
	presets = {
		bottom_search = true,
		command_palette = true,
		inc_rename = false,
		long_message_to_split = true,
		lsp_doc_border = true,
	},
	redirect = { view = "mini" },
	routes = routes,
}

return M
