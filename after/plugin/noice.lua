if not require("utils").is_vim() then
	return nil
end

local icons = require("ui.icons")
local noice = require("noice")

local function pad_right(icon) return icon .. " " end
local function get_search(icon) return icons.misc.search .. icon end

local cmdline = {
	-- view = "cmdline",
	format = {
		cmdline = { pattern = "^:", icon = pad_right(icons.languages.vim), lang = "vim" },
		search_down = { kind = "search", pattern = "^/", icon = get_search(icons.misc.chevron_down), lang = "regex" },
		search_up = { kind = "search", pattern = "^%?", icon = get_search(icons.misc.chevron_up), lang = "regex" },
		filter = { pattern = "^:%s*!", icon = pad_right(icons.languages.bash), lang = "bash" },
		lua = {
			pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" },
			icon = pad_right(icons.languages.lua),
			lang = "lua",
		},
		help = { pattern = "^:%s*he?l?p?%s+", icon = pad_right(icons.misc.help) },
		input = { lang = "vim" },
	},
}

local lsp_progress_format = {
	{ "[{data.progress.percentage}%] ", hl_group = "NoiceLspProgressTitle" },
	{ "{spinner} ", hl_group = "NoiceLspProgressSpinner" },
	{ "[{data.progress.title}] ", hl_group = "NoiceLspProgressTitle" },
}

local lsp = {
	progress = { format = lsp_progress_format },
	hover = { enabled = false },
	override = {
		["vim.lsp.util.convert_input_to_markdown_lines"] = false,
		["vim.lsp.util.stylize_markdown"] = false,
		["cmp.entry.get_documentation"] = false,
	},
	message = { enabled = false },
	signature = { enabled = false },
	-- message = { view = "mini" },
}

local routes = {
	{ view = "split", filter = { event = "msg_show", min_height = 20 } },
	{
		filter = {
			any = {
				{ event = "msg_show", kind = "emsg", find = "E382" }, -- Cannot write, 'buftype' option is set
				{ event = "msg_show", kind = "lua_error", find = "E5108" }, -- CellularAutomation error if folds in file
				{ event = "notify", kind = "warn", find = "Already attached" }, -- navic can only attach to 1 server
			},
		},
		opts = { skip = true },
	},
}

noice.setup({
	cmdline = cmdline,
	messages = { view = "mini", view_error = "mini", view_warn = "mini", view_search = false },
	redirect = { view = "mini" },
	popupmenu = { enabled = true, backend = "cmp", kind_icons = icons.kind_icons },
	commands = {},
	notify = { view = "mini" },
	lsp = lsp,
	presets = { long_message_to_split = true },
	routes = routes,
})
