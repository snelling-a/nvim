local ns_id = vim.api.nvim_create_namespace("visual.highlight.cmdline")

-- Returns positions and `regtype` of cursor/visual selection.
---@return integer, integer, integer, integer, string
local function get_cursor_region()
	local mode = vim.fn.mode()
	local row_s, col_s = unpack(vim.api.nvim_win_get_cursor(0))
	row_s = row_s - 1
	---@type integer,integer
	local row_e, col_e

	-- Visual modes: v, V, Ctrl-V
	if mode:match("^[vV\22]") then
		row_e, col_e = vim.fn.line("v") - 1, vim.fn.col("v") - 1

		if row_s > row_e then
			---@type integer, integer, integer, integer
			row_s, row_e, col_s, col_e = row_e, row_s, col_e, col_s
		end
		if row_s == row_e and col_s > col_e then
			---@type integer, integer
			col_s, col_e = col_e, col_s
		end
	else
		row_e, col_e = row_s, col_s
	end

	if mode == "V" then
		col_s = 0
		col_e = #vim.fn.getline(row_e + 1)
	end

	-- Visual block mode
	if mode == "\22" and col_s > col_e then
		---@type integer, integer
		col_s, col_e = col_e, col_s
	end
	---@type string
	local regtype = mode .. (mode == "\22" and tostring(col_e - col_s + 1) or "")

	return row_s, col_s, row_e, col_e, regtype
end

local start_row, start_col, end_row, end_col, regtype = get_cursor_region()

local function update_region()
	start_row, start_col, end_row, end_col, regtype = get_cursor_region()
end

local function highlight()
	if start_row == end_row and start_col == end_col then
		return
	end

	vim.hl.range(0, ns_id, "CursorLineNr", { start_row, start_col }, { end_row, end_col }, {
		regtype = regtype,
		inclusive = true,
		priority = 300,
	})
	vim.cmd.redraw()
end

local function clear()
	vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
end

local M = {}

function M.setup()
	local group = require("user.autocmd").augroup("highlight_v")

	vim.api.nvim_create_autocmd({ "CmdlineEnter" }, {
		callback = highlight,
		desc = "Highlight region on CmdlineEnter",
		group = group,
	})
	vim.api.nvim_create_autocmd({ "CmdlineLeave" }, {
		callback = clear,
		desc = "Clear highlight on CmdlineLeave",
		group = group,
	})
	vim.api.nvim_create_autocmd({ "ModeChanged" }, {
		callback = update_region,
		desc = "Update selection region on mode change",
		group = group,
		pattern = "*:[vV\x16]*",
	})
	vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
		callback = update_region,
		desc = "Update selection region on cursor move",
		group = group,
	})
end

return M
