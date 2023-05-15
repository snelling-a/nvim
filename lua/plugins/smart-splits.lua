local M = { "mrjones2014/smart-splits.nvim" }

M.keys = {
	{ "<A-h>", function() require("smart-splits").resize_left() end, desc = "Resize split left" },
	{ "<A-j>", function() require("smart-splits").resize_down() end, desc = "Resize split down" },
	{ "<A-k>", function() require("smart-splits").resize_up() end, desc = "Resize split up" },
	{ "<A-l>", function() require("smart-splits").resize_right() end, desc = "Resize split right" },
	{ "<C-h>", function() require("smart-splits").move_cursor_left() end, desc = "Move split cursor left" },
	{ "<C-j>", function() require("smart-splits").move_cursor_down() end, desc = "Move split cursor down" },
	{ "<C-k>", function() require("smart-splits").move_cursor_up() end, desc = "Move split cursor up" },
	{ "<C-l>", function() require("smart-splits").move_cursor_right() end, desc = "Move split cursor right" },
	{ "<leader><leader>h", function() require("smart-splits").swap_buf_left() end, desc = "Swap split buf left" },
	{ "<leader><leader>j", function() require("smart-splits").swap_buf_down() end, desc = "Swap split buf down" },
	{ "<leader><leader>k", function() require("smart-splits").swap_buf_up() end, desc = "Swap split buf up" },
	{ "<leader><leader>l", function() require("smart-splits").swap_buf_right() end, desc = "Swap split buf right" },
}

return M
