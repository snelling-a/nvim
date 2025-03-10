local prisma = " "
local sql = " "
local bash = "󱆃 "
local json = " "
local eslint = " "
local copilot = " "
local css = " "
local deno = " "
local docker = "󰡨 "
local elipsis = "…"
local gear = " "
local harper = "󰊪 "
local html = " "
local lua = " "
local markdown = "󰽛 "
local markdown_h1 = "󰉫 "
local markdown_h2 = "󰉬 "
local markdown_h3 = "󰉭 "
local markdown_h4 = "󰉮 "
local markdown_h5 = "󰉯 "
local markdown_h6 = "󰉰 "
local typescript = "󰛦 "
local vim_icon = " "
local vert = "│"

---@class Icons
return {
	diagnostics = { Error = "󰅚 ", Hint = "󰌶 ", Info = "󰋽 ", Warn = "󰀪 " },
	fillchars = {
		diff = "░",
		eob = " ",
		fold = " ",
		foldclose = "",
		foldopen = "",
		foldsep = vert,
		vert = vert,
	},
	git = { branch = " ", git = "󰊢 ", modified = " " },
	gitsigns = {
		add = { text = "┃" },
		change = { text = "┃" },
		changedelete = { text = "┃" },
		delete = { text = "╽" },
		topdelete = { text = "╿" },
		untracked = { text = "┋" },
	},
	javascript = {
		babel = "󰨥 ",
		node = "󰎙 ",
		prettier = " ",
		yarn = " ",
	},
	listchars = {
		extends = elipsis,
		multispace = "·",
		leadmultispace = " ",
		nbsp = "␣",
		precedes = elipsis,
		tab = "  ",
		trail = "·",
	},
	misc = {
		git = "󰊢 ",
		lazy = "󰒲 ",
		neovim = " ",
	},
	servers = {
		["bash-language-server"] = bash,
		checkmake = " ",
		copilot = copilot,
		css = css,
		["css-lsp"] = css,
		["css-variables-language-server"] = css,
		css_variables = css,
		cssls = css,
		["deno-lint"] = deno,
		["deno-ts"] = deno,
		denols = deno,
		["docker-compose-language-service"] = docker,
		["dockerfile-language-server"] = docker,
		["emmet-language-server"] = html,
		["eslint-lsp"] = eslint,
		harper = harper,
		["harper-ls"] = harper,
		html = html,
		["html-lsp"] = html,
		["json-lsp"] = json,
		lsp = " ",
		["lua diagnostics."] = lua,
		["lua-language-server"] = lua,
		luacheck = lua,
		-- markdown_oxide = obsidian,
		markdownlint = markdown,
		marksman = markdown,
		-- ["obsidian ls"] = obsidian,
		prisma = prisma,
		["prisma-language-server"] = prisma,
		shellcheck = bash,
		sqlls = sql,
		sqlfluff = sql,
		stylelint = " ",
		taplo = gear,
		ts = typescript,
		ts_ls = typescript,
		vimls = vim_icon,
		vimlsp = vim_icon,
		vtsls = typescript,
		yamllint = gear,
		["yaml-language-server"] = gear,
	},
}
