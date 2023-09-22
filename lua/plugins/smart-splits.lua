--- @type LazySpec
local M = {
	"mrjones2014/smart-splits.nvim",
}

M.keys = {
	---@diagnostic disable-next-line: missing-fields
	{
		"<A-h>",
		function() require("smart-splits").resize_left() end,
		desc = "Resize split left",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"<A-j>",
		function() require("smart-splits").resize_down() end,
		desc = "Resize split down",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"<A-k>",
		function() require("smart-splits").resize_up() end,
		desc = "Resize split up",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"<A-l>",
		function() require("smart-splits").resize_right() end,
		desc = "Resize split right",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"<C-h>",
		function() require("smart-splits").move_cursor_left() end,
		desc = "Move split cursor left",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"<C-j>",
		function() require("smart-splits").move_cursor_down() end,
		desc = "Move split cursor down",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"<C-k>",
		function() require("smart-splits").move_cursor_up() end,
		desc = "Move split cursor up",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"<C-l>",
		function() require("smart-splits").move_cursor_right() end,
		desc = "Move split cursor right",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"<leader><leader>h",
		function() require("smart-splits").swap_buf_left() end,
		desc = "Swap split buf left",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"<leader><leader>j",
		function() require("smart-splits").swap_buf_down() end,
		desc = "Swap split buf down",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"<leader><leader>k",
		function() require("smart-splits").swap_buf_up() end,
		desc = "Swap split buf up",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"<leader><leader>l",
		function() require("smart-splits").swap_buf_right() end,
		desc = "Swap split buf right",
	},
}

return M
