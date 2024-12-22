vim.opt_local.list = false
vim.opt_local.spell = false
vim.opt_local.relativenumber = false
vim.opt_local.signcolumn = "no"
vim.opt_local.statuscolumn = ""
vim.opt_local.statusline = [[%(%l/%L%) %{exists('w:quickfix_title')? ' '.w:quickfix_title : ''} ]]

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
	local current = vim.fn.line(".")
	local qflist = vim.fn.getqflist()

	table.remove(qflist, current)
	vim.fn.setqflist(qflist, "r")
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

local map = Config.keymap("Quickfix")

map({ "n" }, "dd", qf_delete_entry, { buffer = bufnr })
map({ "n" }, "<C-t>", "<C-W><CR><C-W>T", { desc = "Open entry in new tab", buffer = bufnr })
map({ "n" }, "<C-s>", function()
	open_split("split")
end, { desc = "Open entry in horizontal split", buffer = bufnr })
map({ "n" }, "<C-v>", function()
	open_split("vsplit")
end, { desc = "Open entry in vertical split", buffer = bufnr })
map({ "n" }, "<C-p>", "<CR><C-W>p", { desc = "Preview entry", buffer = bufnr })
