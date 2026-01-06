vim.api.nvim_create_user_command("Remove", function()
	vim.cmd([[!rm %]])
end, {})

local abbrevs = {
	W = "w",
	Wa = "wa",
	Wq = "wq",
	WQ = "wq",
	Wqa = "wqa",
	WQa = "wqa",
	WQA = "wqa",
	Q = "q",
	Qa = "qa",
	QA = "qa",
	E = "e",
	Vs = "vs",
	VS = "vs",
	Sp = "sp",
	SP = "sp",
}

for lhs, rhs in pairs(abbrevs) do
	vim.cmd.cnoreabbrev(lhs .. " " .. rhs)
end

local function pack_complete()
	local plugins = vim.pack.get()
	---@type string[]
	local names = {}
	for _, plugin in pairs(plugins) do
		names[#names + 1] = plugin.spec.name
	end
	table.sort(names)
	return names
end

vim.api.nvim_create_user_command("PackUpdate", function(opts)
	local names = #opts.fargs > 0 and opts.fargs or nil
	vim.pack.update(names)
end, { nargs = "*", complete = pack_complete, desc = "Update plugins" })

vim.api.nvim_create_user_command("PackClean", function(opts)
	vim.pack.del(opts.fargs)
end, { nargs = "+", complete = pack_complete, desc = "Remove plugin" })

vim.api.nvim_create_user_command("Bw", function(opts)
	local bufdelete = require("bufdelete")
	local arg = opts.fargs[1]
	local buf_opts = { force = opts.bang }
	if arg == "all" then
		bufdelete.all(buf_opts)
	elseif arg == "other" then
		bufdelete.other(buf_opts)
	elseif arg then
		bufdelete.by_name(arg, buf_opts)
	else
		bufdelete.delete(buf_opts)
	end
end, {
	bang = true,
	nargs = "?",
	complete = function()
		local items = { "all", "other" }
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.bo[buf].buflisted then
				local name = vim.fn.bufname(buf)
				if name ~= "" then
					items[#items + 1] = name
				end
			end
		end
		return items
	end,
	desc = "Wipe buffer(s) preserving window layout",
})

vim.api.nvim_create_user_command("Make", function(args)
	if args.bang then
		vim.cmd.make({ bang = false, mods = { silent = true } })
		vim.cmd.copen()
	else
		vim.diagnostic.setloclist({ title = "Diagnostics for " .. vim.fn.expand("%:t") })
	end
end, { bang = true, desc = "Run make" })

vim.api.nvim_create_user_command("DiffTool", function(opts)
	vim.api.nvim_del_user_command("DiffTool")
	vim.cmd.packadd("nvim.difftool")

	if #opts.fargs == 2 then
		require("difftool").open(opts.fargs[1], opts.fargs[2])
	else
		vim.notify("Usage: DiffTool <left> <right>", vim.log.levels.ERROR)
	end
end, { nargs = "*", complete = "file" })
