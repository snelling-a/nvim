local Icons = require("config.ui.icons")
local Util = require("config.util")

local api = vim.api
local augroup = Util.augroup
local autocmd = api.nvim_create_autocmd
local opt = vim.opt

opt.breakindent = true
opt.concealcursor = "nc"
opt.fillchars = Icons.fillchars
opt.foldcolumn = "auto:3"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevelstart = 0
opt.foldmethod = "expr"
opt.guicursor:append("i-c-ci:blinkwait700-blinkoff400-blinkon250-Cursor/lCursor")
opt.guicursor:append("i-ci-ve:ver25")
opt.guicursor:append("n-v-c:block")
opt.guicursor:append("o:hor50")
opt.guicursor:append("r-cr:hor20")
opt.guicursor:append("sm:block-blinkwait175-blinkoff150-blinkon175")
opt.guifont = "Iosevka Nerd Font Mono"
opt.inccommand = "split"
opt.linebreak = true
opt.list = true
opt.listchars = Icons.listchars
opt.numberwidth = 1
opt.pumblend = 30
opt.pumheight = 10
opt.scrolloff = 8
opt.showbreak = string.rep(" ", 4) --[[@as vim.opt.showbreak]]
opt.showcmd = false
-- opt.showmode = false
opt.signcolumn = "yes:2"
opt.smoothscroll = true
opt.splitbelow = true
opt.splitright = true
opt.synmaxcol = 500
opt.termguicolors = true
opt.whichwrap:append({
	["h"] = true,
	["l"] = true,
})
opt.wrap = false

local function hard_mode()
	local Logger = require("config.util.logger"):new("HARD MODE")

	--- @param bad "<down>"|"<left>"|"<right>"|"<up>"
	--- @param good "j"|"h"|"l"|"k"
	local function move_map(bad, good)
		return Util.nmap(bad, function() Logger:warn(string.format("NO! use %s", good)) end, {
			buffer = 0,
			desc = string.format("DON'T USE %s", string.upper(bad)),
		})
	end

	for bad, good in pairs({
		["<down>"] = "j",
		["<left>"] = "h",
		["<right>"] = "l",
		["<up>"] = "k",
	}) do
		move_map(bad, good)
	end
end

local function toggle_buffer_opts()
	if Util.is_file() then
		local opt_local = vim.opt_local
		local cursorline = Util.get_opt_local("cursorline")
		local relativenumber = Util.get_opt_local("relativenumber")

		opt_local.cursorline = not cursorline
		opt_local.number = true
		opt_local.relativenumber = not relativenumber

		hard_mode()
	end
end

local ToggleWindowOptionsGroup = augroup("ToggleWindowOptions")

autocmd({
	"BufLeave",
}, {
	callback = toggle_buffer_opts,
	desc = "Toggle buffer options off",
	group = ToggleWindowOptionsGroup,
})

autocmd("BufEnter", {
	callback = toggle_buffer_opts,
	desc = "Toggle buffer options on",
	group = ToggleWindowOptionsGroup,
})
