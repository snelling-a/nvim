---@type LazySpec
local M = { "mrjones2014/smart-splits.nvim" }

M.keys = {
	{ "<A-left>", desc = "Resize split left" },
	{ "<A-down>", desc = "Resize split down" },
	{ "<A-up>", desc = "Resize split up" },
	{ "<A-right>", desc = "Resize split right" },
	{ "<C-h>", desc = "Move split cursor left" },
	{ "<C-j>", desc = "Move split cursor down" },
	{ "<C-k>", desc = "Move split cursor up" },
	{ "<C-l>", desc = "Move split cursor right" },
	{ "<leader><leader>h", desc = "Swap split buf left" },
	{ "<leader><leader>j", desc = "Swap split buf down" },
	{ "<leader><leader>k", desc = "Swap split buf up" },
	{ "<leader><leader>l", desc = "Swap split buf right" },
}

function M.config()
	local smart_splits = require("smart-splits")
	smart_splits.setup()

	local Keymap = require("keymap")

	---@param lhs string
	---@param rhs function
	---@param desc string
	local function leader(lhs, rhs, desc)
		Keymap.leader(lhs, rhs, { desc = desc })
	end
	---@param lhs string
	---@param rhs function
	---@param desc string
	local function map(lhs, rhs, desc)
		Keymap.nmap(lhs, rhs, { desc = desc })
	end

	map("<A-left>", smart_splits.resize_left, "Resize split left")
	map("<A-down>", smart_splits.resize_down, "Resize split down")
	map("<A-up>", smart_splits.resize_up, "Resize split up")
	map("<A-right>", smart_splits.resize_right, "Resize split right")
	map("<C-h>", smart_splits.move_cursor_left, "Move split cursor left")
	map("<C-j>", smart_splits.move_cursor_down, "Move split cursor down")
	map("<C-k>", smart_splits.move_cursor_up, "Move split cursor up")
	map("<C-l>", smart_splits.move_cursor_right, "Move split cursor right")
	leader("<leader>h", smart_splits.swap_buf_left, "Swap split buf left")
	leader("<leader>j", smart_splits.swap_buf_down, "Swap split buf down")
	leader("<leader>k", smart_splits.swap_buf_up, "Swap split buf up")
	leader("<leader>l", smart_splits.swap_buf_right, "Swap split buf right")
end

return M
