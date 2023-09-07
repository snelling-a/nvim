local M = {}
--- @alias LeftRight table<"right"|"left", string|function>

--- @class Description
--- @field base string
--- @field text LeftRight

--- replacement for vim-unimpaired
--- creates 2 keymaps starting with `"["` and `"]"`
--- @param lhs string
--- @param rhs LeftRight
--- @param desc Description
function M.unimapired(lhs, rhs, desc)
	local nmap = require("config.util").nmap
	local format = string.format

	nmap("[" .. lhs, rhs.left, {
		desc = format("%s %s", desc.base, desc.text.left),
	})

	nmap("]" .. lhs, rhs.right, {
		desc = format("%s %s", desc.base, desc.text.right),
	})
end

local fn = vim.fn

M.unimapired("<space>", {
	left = function()
		local line_nr = fn.line(".")

		fn.append(line_nr - 1, "")
	end,
	right = function()
		local line_nr = fn.line(".") --[[@as number]]

		fn.append(line_nr, "")
	end,
}, {
	base = "Put empty line",
	text = {
		left = "above",
		right = "below",
	},
})

return M
