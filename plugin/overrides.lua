local _print = print

-- luacheck: globals print
---@diagnostic disable-next-line: missing-global-doc
print = function(...)
	---@type any[]
	local args = { ... }
	local new_args = {}
	for _, arg in ipairs(args) do
		table.insert(new_args, vim.inspect(arg))
	end
	_print(unpack(new_args))
end

require("config.notify").setup()
