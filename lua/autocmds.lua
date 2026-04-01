local group = vim.api.nvim_create_augroup("user", {})

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	callback = function(args)
		local bufnr = args.buf
		if vim.bo[bufnr].filetype == "gitcommit" or vim.b[bufnr].last_loc then
			return
		end

		vim.b[bufnr].last_loc = true
		local mark = vim.api.nvim_buf_get_mark(bufnr, '"')
		local line_count = vim.api.nvim_buf_line_count(bufnr)
		if mark[1] > 0 and mark[1] <= line_count then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
	desc = "Go to last loc when opening a buffer",
	group = group,
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	callback = function(args)
		if args.match:match("^%w%w+:[\\/][\\/]") then
			return
		end
		local file = vim.uv.fs_realpath(args.match) or args.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
	desc = "Auto create dir when saving a file, in case some intermediate directory does not exist",
	group = group,
})

vim.api.nvim_create_autocmd({ "CmdlineEnter" }, {
	callback = function()
		if not vim.g.vscode and vim.version().minor >= 12 then
			require("vim._core.ui2").enable({})
		end
	end,
	desc = "Enable native UI on first cmdline entry",
	group = group,
	once = true,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	callback = function(args)
		vim.keymap.set("n", "q", function()
			if vim.bo.filetype == "man" and #vim.fn.getbufinfo({ buflisted = 1 }) <= 1 then
				vim.cmd.qall()
				return
			end
			if not pcall(vim.cmd.close) then
				vim.cmd.bdelete()
			end
		end, { buffer = args.buf, nowait = true, desc = "Close window" })
	end,
	desc = "Map q to close window for transient filetypes",
	group = group,
	pattern = { "oil", "*kulula*", "gitsigns-blame", "help", "man", "checkhealth", "nvim-pack", "nvim-undotree" },
})

vim.api.nvim_create_autocmd({ "TermOpen" }, {
	callback = function()
		vim.opt_local.statuscolumn = ""
		vim.opt_local.number = false
		vim.opt_local.statusline = " Terminal %= " .. vim.o.rulerformat
		vim.cmd.startinsert({ bang = true })
	end,
	desc = "Configure terminal buffer UI and enter insert mode",
	group = group,
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	callback = function()
		vim.hl.on_yank({ higroup = "IncSearch", timeout = 400 })
	end,
	desc = "Highlight yanked text",
	group = group,
})

vim.api.nvim_create_autocmd({ "UIEnter" }, {
	callback = function()
		if vim.g.nvim_startup_time ~= nil then
			return
		end
		vim.g.nvim_startup_time = 0
		local usage = vim.uv.getrusage()
		if usage then
			local user_time = (usage.utime.sec * 1000) + (usage.utime.usec / 1000)
			local sys_time = (usage.stime.sec * 1000) + (usage.stime.usec / 1000)
			vim.g.nvim_startup_time = user_time + sys_time
			vim.notify(("Startup time: %dms"):format(vim.g.nvim_startup_time))
		end
	end,
	desc = "Initializer",
	group = group,
	once = true,
})

local ui_group = vim.api.nvim_create_augroup("user.ui", {})

vim.api.nvim_create_autocmd({ "CmdlineEnter", "FocusLost", "InsertEnter", "WinLeave" }, {
	callback = function()
		if vim.bo.buftype ~= "" then
			return
		end
		vim.wo.relativenumber = false
		vim.wo.cursorline = false
	end,
	desc = "Disable UI elements for unfocused windows",
	group = ui_group,
})

vim.api.nvim_create_autocmd({ "BufEnter", "CmdlineLeave", "FocusGained", "InsertLeave", "WinEnter" }, {
	callback = function()
		if vim.bo.buftype ~= "" then
			return
		end
		vim.wo.number = true
		vim.wo.relativenumber = true
		vim.wo.cursorline = true
	end,
	desc = "Enable UI elements for focused windows",
	group = ui_group,
})

vim.api.nvim_create_autocmd({ "FileChangedShell" }, {
	callback = function(args)
		local bufnr = args.buf
		local path = vim.api.nvim_buf_get_name(bufnr)

		if not vim.uv.fs_stat(path) then
			vim.v.fcs_choice = "ask"
			return
		end

		local new_lines = vim.fn.readfile(path)
		local old_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

		if vim.deep_equal(old_lines, new_lines) then
			vim.v.fcs_choice = ""
			return
		end

		vim.bo[bufnr].modifiable = true
		vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, new_lines)
		vim.bo[bufnr].modified = false
		vim.v.fcs_choice = ""
	end,
	desc = "Reload externally changed files with undo history",
	group = group,
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
	desc = "Resize splits if window got resized",
	group = group,
})
