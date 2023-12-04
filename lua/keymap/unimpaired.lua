---@class keymap.unimpaired
local M = {}

--- replacement for vim-unimpaired
--- creates 2 keymaps starting with `"["` and `"]"`
---@type Unimpaired
function M.unimpaired(lhs, rhs, desc, opts)
	local nmap = require("keymap.util").nmap
	local tbl_extend_force = require("util").tbl_extend_force

	local function get_desc(text)
		return ("%s %s"):format(desc.base, text)
	end

	opts = opts or {}

	nmap(("[%s"):format(lhs), rhs.left, tbl_extend_force(opts, { desc = get_desc(desc.text.left) }))

	nmap(("]%s"):format(lhs), rhs.right, tbl_extend_force(opts, { desc = get_desc(desc.text.right) }))
end

local fn = vim.fn

M.unimpaired("<space>", {
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

M.unimpaired("q", {
	left = vim.cmd.cprevious,
	right = vim.cmd.cnext,
}, {
	base = "",
	text = {
		right = "Next [q]uickfix",
		left = "Previous [q]uickfix",
	},
})

return M
