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
