local function close_and_return()
	local prev_win = vim.fn.win_getid(vim.fn.winnr("#"))
	vim.cmd.cclose()
	vim.cmd.lclose()
	if prev_win ~= 0 and vim.api.nvim_win_is_valid(prev_win) then
		vim.api.nvim_set_current_win(prev_win)
	end
end

local function is_loclist()
	return vim.fn.getloclist(0, { filewinid = 0 }).filewinid ~= 0
end

local function get_entry()
	local list = is_loclist() and vim.fn.getloclist(0) or vim.fn.getqflist()
	return list[vim.fn.line(".")]
end

local function open_entry(cmd)
	local entry = get_entry()
	if not entry or entry.bufnr == 0 then
		return
	end

	close_and_return()
	if cmd then
		vim.cmd(cmd)
	end
	vim.cmd.buffer(entry.bufnr)
	vim.api.nvim_win_set_cursor(0, { entry.lnum, math.max(0, entry.col - 1) })
	vim.cmd.normal({ "zv", bang = true })
end

vim.keymap.set({ "n" }, "<C-v>", function()
	open_entry("vsplit")
end, { buffer = true, desc = "Open in vertical split" })
vim.keymap.set({ "n" }, "<C-s>", function()
	open_entry("split")
end, { buffer = true, desc = "Open in horizontal split" })
vim.keymap.set({ "n" }, "<C-t>", function()
	open_entry("tabnew")
end, { buffer = true, desc = "Open in new tab" })
vim.keymap.set({ "n" }, "<CR>", open_entry, { buffer = true, desc = "Open entry and close" })
vim.keymap.set({ "n" }, "q", close_and_return, { buffer = true, nowait = true, desc = "Close window" })
