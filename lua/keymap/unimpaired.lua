local Keymap = require("keymap.util")
local Util = require("util")

---@class keymap.unimpaired
local M = {}

--- replacement for vim-unimpaired
--- creates 2 keymaps starting with `"["` and `"]"`
---@type Unimpaired
function M.unimpaired(lhs, rhs, desc, opts)
	local function get_desc(text)
		return ("%s %s"):format(desc.base, text)
	end

	opts = opts or {}

	Keymap.nmap(("[%s"):format(lhs), rhs.left, Util.tbl_extend_force(opts, { desc = get_desc(desc.text.left) }))

	Keymap.nmap(("]%s"):format(lhs), rhs.right, Util.tbl_extend_force(opts, { desc = get_desc(desc.text.right) }))
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
	left = function()
		if Util.are_qf_items() then
			vim.cmd.cprevious()
		end
	end,
	right = function()
		if Util.are_qf_items() then
			vim.cmd.cnext()
		end
	end,
}, {
	base = "Jump to ",
	text = {
		right = "next [q]uickfix item",
		left = "previous [q]uickfix item",
	},
})

return M
