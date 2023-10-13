local Util = require("config.util")

local M = {}

--- @alias LeftRight {right:string|function,left:string|function}
--- @alias Description {base:string,text:LeftRight}

--- replacement for vim-unimpaired
--- creates 2 keymaps starting with `"["` and `"]"`
--- @param lhs string
--- @param rhs LeftRight
--- @param desc Description
--- @param opts table?
function M.unimapired(lhs, rhs, desc, opts)
	local tbl_extend = Util.tbl_extend_force
	local format = string.format
	local nmap = Util.nmap

	opts = opts or {}

	nmap(
		"[" .. lhs,
		rhs.left,
		tbl_extend(opts, {
			desc = format("%s %s", desc.base, desc.text.left),
		})
	)

	nmap(
		"]" .. lhs,
		rhs.right,
		tbl_extend(opts, {
			desc = format("%s %s", desc.base, desc.text.right),
		})
	)
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
		left = "above current",
		right = "below current",
	},
})

return M
