local bash = "󱆃 "
local copilot = " "
local css = " "
local curly_brackets = " "
local deno = " "
local docker = "󰡨 "
local elipsis = "…"
local event = " "
local func = "󰊕 "
local gear = " "
local harper = "󰊪 "
local html = " "
local key = " "
local log = "󰦪 "
local lua = " "
local markdown = "󰽛 "
local markdown_h1 = "󰉫 "
local markdown_h2 = "󰉬 "
local markdown_h3 = "󰉭 "
local markdown_h4 = "󰉮 "
local markdown_h5 = "󰉯 "
local markdown_h6 = "󰉰 "
local number = "󰎠 "
local package = " "
local repeat_arrows = "󰑖 "
local right = ""
local trail = "·"
local typescript = "󰛦 "
local variable = "󰀫 "
local vim_icon = " "

---@class user.Icons
local M = {
	dap = {
		Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
		Breakpoint = " ",
		BreakpointCondition = " ",
		BreakpointRejected = { " ", "DiagnosticError" },
		LogPoint = ".>",
	},
	diagnostics = { Error = "󰅚 ", Hint = "󰌶 ", Info = "󰋽 ", Warn = "󰀪 " },
	fillchars = {
		diff = "░",
		eob = " ",
		fold = " ",
		foldclose = right,
		foldopen = "",
		foldsep = "║",
		vert = "│",
	},
	gitsigns = {
		add = { text = "┃" },
		change = { text = "┃" },
		changedelete = { text = "┃" },
		delete = { text = "╽" },
		topdelete = { text = "╿" },
		untracked = { text = "┋" },
	},
	git = { branch = " ", git = "󰊢 ", modified = " " },
	headings = { markdown_h1, markdown_h2, markdown_h3, markdown_h4, markdown_h5, markdown_h6 },
	javascript = {
		babel = "󰨥 ",
		node = "󰎙 ",
		prettier = " ",
		yarn = " ",
	},
	kind_icons = {
		Array = "󱡠 ",
		Boolean = "󰨙 ",
		BreakStatement = "󰙧 ",
		Call = "󰃷 ",
		CaseStatement = "󱃙 ",
		Class = " ",
		Color = " ",
		Constant = " ",
		Constructor = gear,
		ContinueStatement = "→ ",
		Copilot = copilot,
		Declaration = "󰙠 ",
		Delete = "󰩺 ",
		DoStatement = repeat_arrows,
		Enum = " ",
		EnumMember = " ",
		Event = event,
		Field = " ",
		File = " ",
		Folder = " ",
		ForStatement = repeat_arrows,
		Function = func,
		Identifier = variable,
		IfStatement = "󰇉 ",
		Interface = " ",
		Key = key,
		Keyword = key,
		List = "󰚈 ",
		Log = log,
		Lsp = " ",
		Macro = "󰁌 ",
		MarkdownH1 = markdown_h1,
		MarkdownH2 = markdown_h2,
		MarkdownH3 = markdown_h3,
		MarkdownH4 = markdown_h4,
		MarkdownH5 = markdown_h5,
		MarkdownH6 = markdown_h6,
		Method = func,
		Module = package,
		Namespace = curly_brackets,
		Null = "󰟢 ",
		Number = number,
		Object = curly_brackets,
		Operator = " ",
		Package = package,
		Property = " ",
		Reference = " ",
		Regex = " ",
		Repeat = repeat_arrows,
		Scope = curly_brackets,
		Snippet = "󰩫 ",
		Specifier = log,
		Statement = curly_brackets,
		String = "󱆨 ",
		Struct = " ",
		SwitchStatement = "󰺟 ",
		Text = " ",
		Type = " ",
		TypeParameter = " ",
		Unit = " ",
		Value = number,
		Variable = variable,
		WhileStatement = repeat_arrows,
	},
	lazy = {
		cmd = " ",
		favorite = "󰓒 ",
		config = " ",
		event = event,
		ft = " ",
		import = "󰋺 ",
		init = " ",
		keys = "󰌓 ",
		list = { " ", "󰄾 ", "‒", trail },
		loaded = "󰗡 ",
		not_loaded = "󰔟",
		plugin = package,
		runtime = " ",
		source = " ",
		start = right,
		task = " ",
	},
	listchars = {
		extends = elipsis,
		multispace = "·",
		leadmultispace = " ",
		nbsp = "␣",
		precedes = elipsis,
		tab = "  ",
		trail = trail,
	},
	misc = {
		l = "ℓ",
		lazy = "󰒲 ",
		neovim = " ",
		version = " ",
		vim = vim_icon,
		readonly = "󱀰",
		user = " ",
	},
	servers = {
		bashls = bash,
		copilot = copilot,
		css = css,
		css_variables = css,
		cssls = css,
		["deno-lint"] = deno,
		["deno-ts"] = deno,
		denols = deno,
		docker_compose_language_service = docker,
		dockerls = docker,
		emmet_ls = html,
		eslint = " ",
		harper = harper,
		harper_ls = harper,
		html = html,
		jsonls = " ",
		["lua diagnostics."] = lua,
		lua_ls = lua,
		luacheck = lua,
		-- markdown_oxide = obsidian,
		markdownlint = markdown,
		marksman = markdown,
		-- ["obsidian ls"] = obsidian,
		prismals = " ",
		shellcheck = bash,
		sqlls = " ",
		stylelint = " ",
		taplo = gear,
		ts = typescript,
		ts_ls = typescript,
		vimls = vim_icon,
		vimlsp = vim_icon,
		yamllint = gear,
		yamlls = gear,
	},
	ui = {
		separator = "│",
	},
}

return M
