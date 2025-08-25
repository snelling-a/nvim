vim.opt_local.cursorline = true
vim.opt_local.list = false
vim.opt_local.relativenumber = false
vim.opt_local.signcolumn = "no"
vim.opt_local.spell = false
vim.opt_local.wrap = false

vim.opt_local.statuscolumn = "%!v:lua.require'user.qf'.statuscolumn()"

if not vim.g.loaded_cfilter then
	vim.cmd.packadd({ args = { "cfilter" }, bang = false, mods = { emsg_silent = true } })
	vim.g.loaded_cfilter = true
end

---@param winid nil|integer Window handle; if nil, the current window is used
---@return "c"|"l"|nil WinType
local function get_win_type(winid)
	winid = winid or vim.api.nvim_get_current_win()
	local info = vim.fn.getwininfo(winid)[1]

	if info.quickfix == 0 then
		return nil
	elseif info.loclist == 0 then
		return "c"
	else
		return "l"
	end
end

local function qf_delete_entry()
	local wintype = get_win_type()
	local is_qf_list = wintype == "c"

	local list = is_qf_list and vim.fn.getqflist() or vim.fn.getloclist(0)

	local current = vim.fn.line(".")

	table.remove(list, current)

	if is_qf_list then
		vim.fn.setqflist(list, "r")
	else
		vim.fn.setloclist(0, list, "r")
	end

	vim.fn.execute(":" .. tostring(current))
end

---@param cmd "split"|"vsplit" Command to open the split
local function open_split(cmd)
	local wintype = get_win_type()
	if not wintype then
		return
	end
	local line = vim.api.nvim_win_get_cursor(0)[1]

	vim.cmd[wintype .. "close"]()
	vim.cmd.wincmd("p")
	vim.cmd(cmd)
	vim.cmd(line .. wintype:rep(2))
end

local bufnr = vim.api.nvim_get_current_buf()

local Map = require("user.keymap.util")
Map.quit(bufnr)
local map = Map.map("Quickfix")

map({ "n" }, "dd", qf_delete_entry, { buffer = bufnr, desc = "[D]elete entry" })
map({ "n" }, "<C-t>", "<C-W><CR><C-W>T", { buffer = bufnr, desc = "Open entry in new [t]ab" })
map({ "n" }, "<C-s>", function()
	open_split("split")
end, { buffer = bufnr, desc = "Open entry in horizontal split" })
map({ "n" }, "<C-v>", function()
	open_split("vsplit")
end, { buffer = bufnr, desc = "Open entry in [v]ertical split" })
map({ "n" }, "<C-p>", "<CR><C-W>p", { buffer = bufnr, desc = "[P]review entry" })
