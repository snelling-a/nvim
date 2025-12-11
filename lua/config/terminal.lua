local M = {}

local terms = {}

local function git_root()
	local out = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null")
	if vim.v.shell_error == 0 then
		return vim.trim(out)
	end
	return nil
end

local function get_win_config()
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)
	return {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
	}
end

local function resize()
	for _, t in pairs(terms) do
		if t.win and vim.api.nvim_win_is_valid(t.win) then
			vim.api.nvim_win_set_config(t.win, get_win_config())
		end
	end
end

local function open(opts)
	opts = opts or {}
	local cmd = opts.cmd
	local key = cmd or "default"
	local t = terms[key]

	if not t then
		t = { win = nil, buf = nil }
		terms[key] = t
	end

	if t.win and vim.api.nvim_win_is_valid(t.win) then
		vim.api.nvim_win_hide(t.win)
		t.win = nil
		return
	end

	if not t.buf or not vim.api.nvim_buf_is_valid(t.buf) then
		t.buf = vim.api.nvim_create_buf(false, true)
		vim.bo[t.buf].bufhidden = "hide"
	end

	local config = get_win_config()
	config.style = "minimal"
	config.border = "rounded"
	t.win = vim.api.nvim_open_win(t.buf, true, config)
	vim.wo[t.win].winblend = 0
	vim.wo[t.win].scrolloff = 0

	if vim.bo[t.buf].buftype ~= "terminal" then
		local term_cmd = cmd
		if opts.dir then
			term_cmd = string.format("cd %s && %s", vim.fn.shellescape(opts.dir), cmd or "$SHELL")
		end
		vim.cmd.terminal(term_cmd)
		vim.opt_local.number = false
		vim.opt_local.relativenumber = false
		vim.opt_local.signcolumn = "no"

		vim.api.nvim_create_autocmd("TermClose", {
			buffer = t.buf,
			callback = function()
				if t.win and vim.api.nvim_win_is_valid(t.win) then
					vim.api.nvim_win_close(t.win, true)
					t.win = nil
				end
				t.buf = nil
				if opts.on_exit then
					opts.on_exit()
				end
			end,
		})
	end

	vim.keymap.set("t", "<C-/>", function()
		open(opts)
	end, { buffer = t.buf, desc = "Toggle terminal" })

	if not cmd then
		vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { buffer = t.buf, desc = "Exit terminal mode" })
	end

	vim.cmd.startinsert()
end

function M.toggle()
	open()
end

function M.lazygit()
	open({
		cmd = "lazygit",
		dir = git_root(),
		on_exit = function()
			vim.cmd.checktime()
			vim.api.nvim_exec_autocmds("User", { pattern = "LazyGitClosed" })
		end,
	})
end

function M.setup()
	vim.keymap.set("n", "<C-/>", M.toggle, { desc = "Toggle terminal" })
	vim.keymap.set("n", "<leader>gg", M.lazygit, { desc = "Lazygit" })

	vim.env.EDITOR = 'nvim --server "$NVIM" --remote'

	vim.api.nvim_create_autocmd("VimResized", {
		callback = resize,
	})

	vim.api.nvim_create_autocmd("User", {
		pattern = "LazyGitClosed",
		callback = function()
			local ok, gitsigns = pcall(require, "gitsigns")
			if ok then
				gitsigns.refresh()
			end
		end,
	})
end

return M
