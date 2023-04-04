if not require("utils").is_vim() then
	return nil
end

local icons = require("utils.icons")
local noice = require("noice")

local cmdline = {
	-- view = "cmdline",
	format = {
		cmdline = { pattern = "^:", icon = icons.languages.vim, lang = "vim" },
		search_down = { kind = "search", pattern = "^/", icon = icons.misc.search .. "", lang = "regex" },
		search_up = { kind = "search", pattern = "^%?", icon = icons.misc.search .. "", lang = "regex" },
		filter = { pattern = "^:%s*!", icon = icons.languages.bash, lang = "bash" },
		lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
		help = { pattern = "^:%s*he?l?p?%s+", icon = icons.misc.help },
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
	signature = { enabled = false },
	message = { view = "mini" },
}

local routes = {
	{ view = "split", filter = { event = "msg_show", min_height = 20 } },
	{
		filter = { event = "msg_show", kind = "emsg", find = "E5108" }, -- Cannot write, 'buftype' option is set
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
