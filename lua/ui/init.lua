require("ui.qf")
require("ui.shortmess")
require("ui.tabline")

--- Toggle buffer options for active and inactive buffers
---@param ev Ev
---@param state boolean
local function toggle_buffer_opts(ev, state)
	local is_file = vim.bo[ev.buf].buftype == ""
	local opt_local = vim.opt_local
	if not is_file then
		opt_local.numberwidth = 1
		opt_local.number = false
		opt_local.cursorline = false
		opt_local.statuscolumn = ""
	else
		opt_local.cursorline = state --[[@as vim.opt.cursorline]]
		opt_local.number = true
		opt_local.relativenumber = state --[[@as vim.opt.relativenumber]]
	end
end

local group = require("autocmd").augroup("ToggleWindowOptions")
local autocmd = vim.api.nvim_create_autocmd
autocmd({
	"BufEnter",
	"CmdlineLeave",
	"FocusGained",
	"WinEnter",
}, {
	---@param ev Ev
	callback = function(ev)
		toggle_buffer_opts(ev, true)
	end,
	desc = "Toggle buffer options on",
	group = group,
})
autocmd({
	"BufLeave",
	"WinLeave",
	"FocusLost",
	"CmdlineEnter",
}, {
	---@param ev Ev
	callback = function(ev)
		toggle_buffer_opts(ev, false)
		if ev.event == "CmdlineEnter" then
			vim.cmd.redraw()
		end
	end,
	desc = "Toggle buffer options off",
	group = group,
})

---@class UI
local M = setmetatable({}, {
	__index = function(self, field)
		self[field] = require(("ui.%s"):format(field))
		return self[field]
	end,
})

--- get higlight for given hl group
---@param name string see |highlight-groups|
---@param what What?
---@param mode "gui"|"cterm"?
---@return string|nil
function M.get_hl(name, what, mode)
	local fn = vim.fn
	what = what or "fg"
	mode = mode or "gui"

	return fn.synIDattr(fn.synIDtrans(fn.hlID(name)), what, mode)
end

return M
