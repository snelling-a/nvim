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

	opts = Util.tbl_extend_force(opts or {}, { silent = true })

	Keymap.nmap(("[%s"):format(lhs), rhs.left, Util.tbl_extend_force(opts, { desc = get_desc(desc.text.left) }))

	Keymap.nmap(("]%s"):format(lhs), rhs.right, Util.tbl_extend_force(opts, { desc = get_desc(desc.text.right) }))
end

M.unimpaired("<space>", {
	left = function()
		vim.cmd("put! =repeat(nr2char(10), v:count1)|silent ']+")
	end,
	right = function()
		vim.cmd("put =repeat(nr2char(10), v:count1)|silent '[-")
	end,
}, {
	base = "Put empty line",
	text = {
		left = "above current",
		right = "below current",
	},
})

M.unimpaired("l", {
	left = function()
		if Util.are_loc_items() then
			vim.cmd.lprevious()
		end
	end,
	right = function()
		if Util.are_loc_items() then
			vim.cmd.lnext()
		end
	end,
}, {
	base = "Jump to ",
	text = { right = "next [l]ocation list item", left = "previous [l]ocation list item" },
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

M.unimpaired("p", {
	left = function()
		if Util.is_modifiable() then
			vim.cmd.execute({ args = { ("'move -1-%s'"):format(vim.v.count1) } })
		end
	end,
	right = function()
		if Util.is_modifiable() then
			vim.cmd.execute({ args = { ("'move +%s'"):format(vim.v.count1) } })
		end
	end,
}, {
	base = "Delete current line and [p]ut it ",
	text = { right = "above", left = "below" },
})

return M
