local bw_complete_opts = {
	ALL = "all",
	OTHERS = "others",
}

vim.api.nvim_create_user_command("Bw", function(args)
	local Bdelete = require("user.command.bdelete")

	if args.bang or args.fargs[1] == bw_complete_opts.OTHERS then
		return Bdelete.others()
	end

	if args.fargs[1] == bw_complete_opts.ALL then
		return Bdelete.all()
	end

	return Bdelete()
end, {
	bang = true,
	complete = function()
		local opts = vim.tbl_values(bw_complete_opts)
		local files = {}
		for _, b in ipairs(vim.api.nvim_list_bufs()) do
			local filename = (vim.api.nvim_buf_get_name(b))
			if filename ~= "" then
				vim.list_extend(files, { vim.fn.fnamemodify(filename, ":.") })
			end
		end
		table.sort(files)
		return vim.list_extend(opts, files)
	end,
	desc = "Close buffers",
	nargs = "?",
})

vim.api.nvim_create_user_command("ColorMyPencils", function()
	local normal = vim.api.nvim_get_hl(0, {
		name = "Normal",
	})
	local normal_float = vim.api.nvim_get_hl(0, {
		name = "NormalFloat",
	})

	if vim.tbl_get(normal_float, "bg") or vim.tbl_get(normal, "bg") then
		vim.api.nvim_set_hl(0, "Normal", {
			bg = "none",
		})
		vim.api.nvim_set_hl(0, "NormalFloat", {
			bg = "none",
		})
	else
		vim.cmd.colorscheme(vim.g.colors_name)
	end
end, { desc = "Toggle transparent background" })

vim.api.nvim_create_user_command("CHMOD", function()
	local fname = vim.fn.expand("%:p")
	local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]

	if not first_line or not first_line:match("^#!") then
		local okay, choice =
			pcall(vim.fn.confirm, ("No shebang found\nmake %q executable?"):format(fname), "&Yes\n&No\n&Cancel")
		if not okay or choice ~= 1 then
			vim.notify(("Did not make %q executable"):format(fname), vim.log.levels.WARN)
			return
		end
	end

	local okay, success = pcall(vim.fn.setfperm, fname, "rwxr-xr--")
	if not okay or success == 0 then
		vim.notify(("Failed to make %q executable"):format(fname), vim.log.levels.ERROR)
		return
	end

	vim.notify(fname .. " is now executable")
end, {})

vim.api.nvim_create_user_command("Make", function(args)
	if args.bang then
		vim.cmd.make({
			bang = false,
			mods = { silent = true },
		})
		vim.cmd.copen()
	else
		vim.diagnostic.setloclist({
			title = "Diagnostics for " .. vim.fn.expand("%:t"),
		})
	end
end, {
	bang = true,
	desc = "Run make",
})

vim.api.nvim_create_user_command("Scratch", function(args)
	local cmd = args.bang and "belowright 10" or "vertical "

	vim.cmd(cmd .. "new")
	local bufnr = vim.api.nvim_get_current_buf()

	for name, value in pairs({
		filetype = "scratch",
		buftype = "nofile",
		bufhidden = "hide",
		swapfile = false,
		modifiable = true,
	}) do
		vim.api.nvim_set_option_value(name, value, { buf = bufnr })
	end

	require("user.keymap.util").quit(bufnr)

	vim.schedule(function()
		vim.cmd.startinsert()
	end)
end, { desc = "Open a scratch buffer", nargs = 0, bang = true })

vim.api.nvim_create_user_command("DiffTool", function(opts)
	vim.api.nvim_del_user_command("DiffTool")
	vim.cmd.packadd("nvim.difftool")

	if #opts.fargs == 2 then
		require("difftool").open(opts.fargs[1], opts.fargs[2])
	else
		vim.notify("Usage: DiffTool <left> <right>", vim.log.levels.ERROR)
	end
end, { nargs = "*", complete = "file" })
