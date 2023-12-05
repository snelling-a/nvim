---@type LazySpec
local M = { "mrjones2014/smart-splits.nvim" }

M.event = { "FileLoaded" }

---@diagnostic disable-next-line: assign-type-mismatch
function M.keys()
	local smart_splits = require("smart-splits")

	return {
		{ "<A-left>", smart_splits.resize_left, desc = "Resize split left" },
		{ "<A-down>", smart_splits.resize_down, desc = "Resize split down" },
		{ "<A-up>", smart_splits.resize_up, desc = "Resize split up" },
		{ "<A-right>", smart_splits.resize_right, desc = "Resize split right" },
		{ "<C-h>", smart_splits.move_cursor_left, desc = "Move split cursor left" },
		{ "<C-j>", smart_splits.move_cursor_down, desc = "Move split cursor down" },
		{ "<C-k>", smart_splits.move_cursor_up, desc = "Move split cursor up" },
		{ "<C-l>", smart_splits.move_cursor_right, desc = "Move split cursor right" },
		{ "<leader><leader>h", smart_splits.swap_buf_left, desc = "Swap split buf left" },
		{ "<leader><leader>j", smart_splits.swap_buf_down, desc = "Swap split buf down" },
		{ "<leader><leader>k", smart_splits.swap_buf_up, desc = "Swap split buf up" },
		{ "<leader><leader>l", smart_splits.swap_buf_right, desc = "Swap split buf right" },
	}
end

return M
