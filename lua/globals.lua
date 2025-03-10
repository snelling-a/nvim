vim.g.disabled_filetypes = {
	"copilot-chat",
	"fugitive",
	"fugitiveblame",
	"gitsigns-blame",
	"grug-far",
	"grug-far-help",
	"grug-far-history",
	"help",
	"lazy",
	"log",
	"man",
	"mason",
	"minifiles",
	"ministarter",
	"neotest-attach",
	"neotest-output",
	"neotest-output-panel",
	"neotest-summary",
	"nofile",
	"notify",
	"qf",
	"scratch",
}

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
