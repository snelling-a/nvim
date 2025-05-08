local bash = "󱆃 "
local copilot = " "
local css = " "
local deno = " "
local docker = "󰡨 "
local elipsis = "…"
local eslint = " "
local gear = " "
local harper = "󰊪 "
local html = " "
local json = " "
local lua = " "
local markdown = "󰽛 "
-- local markdown_h1 = "󰉫 "
-- local markdown_h2 = "󰉬 "
-- local markdown_h3 = "󰉭 "
-- local markdown_h4 = "󰉮 "
-- local markdown_h5 = "󰉯 "
-- local markdown_h6 = "󰉰 "
local obsidian = "󰋙 "
local prisma = " "
local sql = " "
local typescript = "󰛦 "
local vert = "│"
local vim_icon = " "

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
		leadmultispace = " ",
		multispace = "·",
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
		eslint = eslint,
		harper = harper,
		["harper-ls"] = harper,
		html = html,
		["html-lsp"] = html,
		["json-lsp"] = json,
		json = json,
		lsp = " ",
		["lua diagnostics."] = lua,
		["lua-language-server"] = lua,
		luacheck = lua,
		markdownlint = markdown,
		["markdown-oxide"] = obsidian,
		marksman = markdown,
		["obsidian ls"] = obsidian,
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
		["vim-language-server"] = vim_icon,
		vtsls = typescript,
		yamllint = gear,
		["yaml-language-server"] = gear,
	},
}
