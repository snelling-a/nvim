--- @alias LeftRight table<"right"|"left", string|function>

--- @class Description
--- @field base string
--- @field text LeftRight

--- replacement for vim-unimpaired
--- creates 2 keymaps starting with `"["` and `"]"`
--- @param lhs string
--- @param rhs LeftRight
--- @param desc Description
local function unimapired(lhs, rhs, desc)
	local util = require("config.util")
	local format = string.format

	util.nmap("[" .. lhs, rhs.left, {
		desc = format("%s %s", desc.base, desc.text.left),
	})

	util.nmap("]" .. lhs, rhs.right, {
		desc = format("%s %s", desc.base, desc.text.right),
	})
end

unimapired("<space>", {
	left = function()
		local line_nr = vim.fn.line(".")

		vim.fn.append(line_nr - 1, "")
	end,
	right = function()
		local line_nr = vim.fn.line(".") --[[@as number]]

		vim.fn.append(line_nr, "")
	end,
}, {
	base = "Put empty line",
	text = {
		left = "above",
		right = "below",
	},
})
