-- local bash = "󱆃 "
-- local copilot = " "
-- local css = " "
-- local deno = " "
-- local docker = "󰡨 "
-- local elipsis = "…"
-- local eslint = " "
-- local gear = " "
-- local harper = "󰊪 "
-- local html = " "
-- local json = " "
-- local lua = " "
-- local markdown = "󰽛 "
-- -- local markdown_h1 = "󰉫 "
-- -- local markdown_h2 = "󰉬 "
-- -- local markdown_h3 = "󰉭 "
-- -- local markdown_h4 = "󰉮 "
-- -- local markdown_h5 = "󰉯 "
-- -- local markdown_h6 = "󰉰 "
-- local obsidian = "󰋙 "
-- local prisma = " "
-- local sql = " "
-- local typescript = "󰛦 "
-- local vert = "│"
-- local vim_icon = " "
--
-- local diagnostics = { Error = "󰅚 ", Hint = "󰌶 ", Info = "󰋽 ", Warn = "󰀪 " }

-- return {
-- 	diagnostics = diagnostics,
-- 	fillchars = {
-- 		diff = "░",
-- 		eob = " ",
-- 		fold = " ",
-- 		foldclose = "",
-- 		foldopen = "",
-- 		foldsep = vert,
-- 		vert = vert,
-- 	},
-- 	git = { branch = " ", git = "󰊢 ", modified = " " },
-- 	gitsigns = {
-- 		add = { text = "┃" },
-- 		change = { text = "┃" },
-- 		changedelete = { text = "┃" },
-- 		delete = { text = "╽" },
-- 		topdelete = { text = "╿" },
-- 		untracked = { text = "┋" },
-- 	},
-- 	javascript = {
-- 		babel = "󰨥 ",
-- 		node = "󰎙 ",
-- 		prettier = " ",
-- 		yarn = " ",
-- 	},
-- 	symbol_kinds = {
-- 		Class = "󰠱 ",
-- 		Color = "󰏘 ",
-- 		Constant = "󰏿 ",
-- 		Constructor = " ",
-- 		Enum = " ",
-- 		EnumMember = " ",
-- 		Event = " ",
-- 		Field = "󰜢 ",
-- 		File = "󰈙 ",
-- 		Folder = "󰉋 ",
-- 		Function = "󰊕 ",
-- 		Interface = " ",
-- 		Keyword = "󰌋 ",
-- 		Method = "󰆧 ",
-- 		Module = " ",
-- 		Operator = "󰆕 ",
-- 		Property = "󰜢 ",
-- 		Reference = "󰈇 ",
-- 		Snippet = "󰩫 ",
-- 		Struct = "󰙅 ",
-- 		Text = "󰉿 ",
-- 		TypeParameter = " ",
-- 		Unit = "󰑭 ",
-- 		Value = "󰎠 ",
-- 		Variable = "󰀫 ",
-- 	},
-- 	listchars = {
-- 		extends = elipsis,
-- 		leadmultispace = " ",
-- 		multispace = "·",
-- 		nbsp = "␣",
-- 		precedes = elipsis,
-- 		tab = "  ",
-- 		trail = "·",
-- 	},
-- 	misc = {
-- 		git = "󰊢 ",
-- 		lazy = "󰒲 ",
-- 		neovim = " ",
-- 	},
-- 	qf = {
-- 		type_mapping = {
-- 			E = { text = diagnostics.Error, hl = "DiagnosticSignError" },
-- 			W = { text = diagnostics.Warn, hl = "DiagnosticSignWarn" },
-- 			I = { text = diagnostics.Info, hl = "DiagnosticSignInfo" },
-- 			N = { text = diagnostics.Hint, hl = "DiagnosticSignHint" },
-- 		},
-- 	},
-- 	servers = {
-- 		["bash-language-server"] = bash,
-- 		checkmake = " ",
-- 		copilot = copilot,
-- 		css = css,
-- 		["css-lsp"] = css,
-- 		["css-variables-language-server"] = css,
-- 		css_variables = css,
-- 		cssls = css,
-- 		["deno-lint"] = deno,
-- 		["deno-ts"] = deno,
-- 		denols = deno,
-- 		["docker-compose-language-service"] = docker,
-- 		["dockerfile-language-server"] = docker,
-- 		["emmet-language-server"] = html,
-- 		["eslint-lsp"] = eslint,
-- 		eslint = eslint,
-- 		harper = harper,
-- 		["harper-ls"] = harper,
-- 		html = html,
-- 		["html-lsp"] = html,
-- 		["json-lsp"] = json,
-- 		json = json,
-- 		lsp = " ",
-- 		["lua diagnostics."] = lua,
-- 		["lua-language-server"] = lua,
-- 		luacheck = lua,
-- 		markdownlint = markdown,
-- 		["markdown-oxide"] = obsidian,
-- 		marksman = markdown,
-- 		["obsidian ls"] = obsidian,
-- 		prisma = prisma,
-- 		["prisma-language-server"] = prisma,
-- 		shellcheck = bash,
-- 		sqlls = sql,
-- 		sqlfluff = sql,
-- 		stylelint = " ",
-- 		taplo = gear,
-- 		ts = typescript,
-- 		ts_ls = typescript,
-- 		vimls = vim_icon,
-- 		["vim-language-server"] = vim_icon,
-- 		vtsls = typescript,
-- 		yamllint = gear,
-- 		["yaml-language-server"] = gear,
-- 	},
-- }

local vert = "│"
local elipsis = "…"
local diagnostics = {
	Error = " ",
	Warn = " ",
	Info = " ",
	Hint = " ",
}

local bash = " "
local copilot = " "
local css = " "
local deno = " "
local docker = "󰡨 "
local eslint = " "
local gear = " "
local html = " "
local json = " "
local lua = " "
local markdown = " "
local obsidian = "󱓧 "
local prisma = " "
local sql = " "
local typescript = " "
local vim_icon = " "

-- helpers
local function textIcon(char)
	return { text = char }
end

-- categories
local fillchars = {
	diff = "░",
	eob = " ",
	fold = " ",
	foldclose = "",
	foldopen = "",
	foldsep = vert,
	vert = vert,
}

local git = {
	branch = " ",
	git = "󰊢 ",
	modified = " ",
}

local gitsigns = {
	add = textIcon("┃"),
	change = textIcon("┃"),
	changedelete = textIcon("┃"),
	delete = textIcon("╽"),
	topdelete = textIcon("╿"),
	untracked = textIcon("┋"),
}

local javascript = {
	babel = "󰨥 ",
	node = "󰎙 ",
	prettier = " ",
	yarn = " ",
}

local symbol_kinds = {
	Class = "󰠱 ",
	Color = "󰏘 ",
	Constant = "󰏿 ",
	Constructor = " ",
	Enum = " ",
	EnumMember = " ",
	Event = " ",
	Field = "󰜢 ",
	File = "󰈙 ",
	Folder = "󰉋 ",
	Function = "󰊕 ",
	Interface = " ",
	Keyword = "󰌋 ",
	Method = "󰆧 ",
	Module = " ",
	Operator = "󰆕 ",
	Property = "󰜢 ",
	Reference = "󰈇 ",
	Snippet = "󰩫 ",
	Struct = "󰙅 ",
	Text = "󰉿 ",
	TypeParameter = " ",
	Unit = "󰑭 ",
	Value = "󰎠 ",
	Variable = "󰀫 ",
}

local listchars = {
	extends = elipsis,
	precedes = elipsis,
	leadmultispace = " ",
	multispace = "·",
	nbsp = "␣",
	tab = "  ",
	trail = "·",
}

local misc = {
	git = "󰊢 ",
	lazy = "󰒲 ",
	neovim = " ",
}

local qf = {
	type_mapping = {
		E = { text = diagnostics.Error, hl = "DiagnosticSignError" },
		W = { text = diagnostics.Warn, hl = "DiagnosticSignWarn" },
		I = { text = diagnostics.Info, hl = "DiagnosticSignInfo" },
		N = { text = diagnostics.Hint, hl = "DiagnosticSignHint" },
	},
}

local servers = {
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
	harper = "󰎛 ",
	["harper-ls"] = "󰎛 ",
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
}

---@class Icons
local M = {
	diagnostics = diagnostics,
	fillchars = fillchars,
	git = git,
	gitsigns = gitsigns,
	javascript = javascript,
	listchars = listchars,
	misc = misc,
	qf = qf,
	servers = servers,
	symbol_kinds = symbol_kinds,
}

setmetatable(M.servers, {
	__index = function(_, _)
		return M.servers.lsp
	end,
})

return M
