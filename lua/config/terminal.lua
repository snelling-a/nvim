local M = {}

local win = nil
local buf = nil

local function create_buf()
	buf = vim.api.nvim_create_buf(false, true)
	vim.bo[buf].bufhidden = "hide"
	return buf
end

local function create_win()
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
	})

	vim.wo[win].winblend = 0
	return win
end

function M.toggle()
	if win and vim.api.nvim_win_is_valid(win) then
		vim.api.nvim_win_hide(win)
		win = nil
		return
	end

	if not buf or not vim.api.nvim_buf_is_valid(buf) then
		create_buf()
	end

	create_win()

	if vim.bo[buf].buftype ~= "terminal" then
		vim.cmd.terminal()
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.signcolumn = "no"
	end

	vim.keymap.set("t", "<C-/>", M.toggle, { buffer = buf, desc = "Toggle terminal" })
	vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { buffer = buf, desc = "Exit terminal mode" })

	vim.cmd.startinsert()
end

function M.setup()
	vim.keymap.set("n", "<C-/>", M.toggle, { desc = "Toggle terminal" })
end

return M
