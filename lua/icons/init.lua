local vert = "│"
local elipsis = "…"
local diagnostics = {
	Error = " ",
	Warn = " ",
	Info = " ",
	Hint = "󱈸 ",
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
local obsidian = "⛰ "
local prisma = " "
local sql = " "
local typescript = " "
local vim_icon = " "
local golang = " "
local harper = "󰎛 "

---@param char string?
---@return { text: string }
local function textIcon(char)
	if not char or #char == 0 then
		char = "┃"
	end
	return { text = char }
end

local fillchars = {
	diff = "░",
	eob = " ",
	fold = " ",
	foldclose = "",
	msgsep = "─",
	foldopen = "",
	foldsep = vert,
	vert = vert,
	foldinner = " ",
}

local git = {
	branch = " ",
	git = "󰊢 ",
	modified = " ",
}

local gitsigns = {
	add = textIcon(),
	change = textIcon(),
	changedelete = textIcon(),
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
	chevron_right = " ",
	document = "󰧮 ",
	done = " ",
	folder_closed = "󰉋 ",
	folder_open = " ",
	git = "󰊢 ",
	lazy = "󰒲 ",
	neovim = " ",
	treesitter = " ",
	unknown = " ",
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
	["even better toml"] = " ",
	harper = harper,
	["harper-ls"] = harper,
	html = html,
	["html-lsp"] = html,
	["json-lsp"] = json,
	json = json,
	jsonc = json,
	lsp = " ",
	lua = "󱘎 ", -- treesitter playground
	["lua diagnostics."] = lua,
	["lua-language-server"] = lua,
	luacheck = lua,
	markdownlint = markdown,
	["markdown-oxide"] = "󱓧 ",
	marksman = markdown,
	["obsidian-ls"] = obsidian,
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
	gopls = golang,
	staticcheck = golang,
	-- gofmt
	syntax = golang,
	compiler = golang,
	unusedfunc = golang,
	unusedparams = golang,
	modernize = golang,
	structtag = golang,
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
}

setmetatable(M.servers, {
	__index = function(_, _)
		return M.servers.lsp
	end,
})

return M
