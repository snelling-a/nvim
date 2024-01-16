local opt = vim.opt_local

opt.list = false
opt.cursorline = true
opt.spell = false
opt.statuscolumn = require("ui.status.column").basic

local function map(lhs, rhs, desc)
	require("keymap").nmap(lhs, rhs, { buffer = true, desc = desc })
end
opt.statusline = [[%(%l/%L%) %{exists('w:quickfix_title')? ' '.w:quickfix_title : ''} ]]

local function close()
	if require("util").is_loc_list() then
		return vim.cmd.lclose()
	else
		return vim.cmd.cclose()
	end
end
local function q()
	return require("autocmd").easy_quit(close)
end

map("q", q, "Close quickfix")
map("<C-c>", q, "Close quickfix")

vim.cmd.packadd("cfilter")
