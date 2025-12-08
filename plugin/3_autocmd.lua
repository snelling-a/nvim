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
	group = group,
	once = true,
	callback = function()
		if vim.version().minor >= 12 then
			require("vim._extui").enable({})
		end
	end,
})

vim.api.nvim_create_autocmd({ "TermOpen" }, {
	group = group,
	command = "setl stc= nonumber | startinsert!",
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	callback = function()
		vim.hl.on_yank({ higroup = "IncSearch", timeout = 400 })
	end,
	group = group,
})

vim.api.nvim_create_autocmd({ "UIEnter" }, {
	group = group,
	once = true,
	callback = function()
		if vim.g.strive_startup_time ~= nil then
			return
		end
		vim.g.strive_startup_time = 0
		local usage = vim.uv.getrusage()
		if usage then
			local user_time = (usage.utime.sec * 1000) + (usage.utime.usec / 1000)
			local sys_time = (usage.stime.sec * 1000) + (usage.stime.usec / 1000)
			vim.g.nvim_startup_time = user_time + sys_time
			vim.notify(("Startup time: %dms"):format(vim.g.nvim_startup_time))
		end
	end,
	desc = "Initializer",
})
