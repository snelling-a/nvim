local bw_complete_opts = {
	ALL = "all",
	OTHERS = "others",
}

vim.api.nvim_create_user_command("Bw", function(ctx)
	local Bdelete = require("bdelete")

	if ctx.bang or ctx.fargs[1] == bw_complete_opts.OTHERS then
		return Bdelete.others()
	end

	if ctx.fargs[1] == bw_complete_opts.ALL then
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

vim.api.nvim_create_user_command("Make", function(ctx)
	local bang = ctx.bang ~= true
	vim.cmd.make({
		bang = bang,
		mods = { silent = true },
	})

	if not bang then
		Config.keymap.maps.feedkeys("<Enter>")
	end

	vim.cmd.copen()
end, {
	bang = true,
	desc = "Run make",
})

vim.api.nvim_create_user_command("ReadLog", require("log").read_log, { desc = "Read log to quickfix" })

vim.api.nvim_create_user_command("Scratch", function(ctx)
	local cmd = ctx.bang and "belowright 10" or "vertical "

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

	Config.util.easy_quit(bufnr)

	vim.schedule(function()
		vim.cmd.startinsert()
	end)
end, { desc = "Open a scratch buffer", nargs = 0 })
