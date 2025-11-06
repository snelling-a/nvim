vim.g.disabled_filetypes = {
	"blink-cmp-menu",
	"copilot-chat",
	"fidget",
	"fugitive",
	"fugitiveblame",
	"gitsigns-blame",
	"grug-far",
	"grug-far-help",
	"grug-far-history",
	"help",
	"lazy",
	"log",
	"mason",
	"minifiles",
	"minipick",
	"ministarter",
	"neotest-attach",
	"neotest-output",
	"neotest-output-panel",
	"neotest-summary",
	"nofile",
	"notify",
	"nvim-undotree",
	"qf",
	"scratch",
	"toggleterm",
}
vim.g.relativenumber = true
vim.g.inlay_hints = true

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
