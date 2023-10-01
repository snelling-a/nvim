local Util = require("config.util")

local function current_line_blame_formatter_nc(_, blame_info, _)
	if blame_info.committer == "Not Committed Yet" then
		return {
			{
				"",
				"None",
			},
		}
	end
end

local function on_attach(bufnr)
	local bufname = vim.api.nvim_buf_get_name(bufnr)
	if vim.tbl_contains(require("config.util.constants").no_format, bufname, {}) then
		return
	end

	local gs = package.loaded.gitsigns

	local buf_opts = {
		buffer = bufnr,
		expr = true,
	}

	local function preview()
		Util.scroll_center()
		gs.preview_hunk_inline()
	end

	require("config.keymap.unimpaired").unimapired("c", {
		left = function()
			if vim.wo.diff then
				return "[c"
			end
			vim.schedule(function()
				gs.prev_hunk()
				preview()
			end)
			return "<Ignore>"
		end,
		right = function()
			if vim.wo.diff then
				return "]c"
			end
			vim.schedule(function()
				gs.next_hunk()
				preview()
			end)
			return "<Ignore>"
		end,
	}, {
		base = "Jump to ",
		text = {
			right = "next [c]hange (hunk)",
			left = "previous [c]hange (hunk)",
		},
		buf_opts,
	})

	local function map(mode, lhs, rhs, opts) return Util.map(mode, lhs, rhs, opts) end
	local function map_l(lhs, rhs, desc)
		return Util.map_leader(lhs, rhs, {
			desc = desc,
		})
	end

	map_l("hD", function() gs.diffthis("~") end, "[D]iff this")
	map_l("hR", gs.reset_buffer, "[R]eset Buffer")
	map_l("hS", gs.stage_buffer, "[S]tage Buffer")
	map_l("hb", function()
		gs.blame_line({
			full = true,
		})
	end, "[B]lame [L]ine")
	map_l("hd", gs.diffthis, "[D]iff this")
	map_l("hp", gs.preview_hunk, "[P]review [H]unk")
	map_l("hq", gs.setqflist, "Populate the [q]uickfix list with [h]unks")
	map_l("hu", gs.undo_stage_hunk, "[U]ndo Stage [H]unk")
	map_l("tb", gs.toggle_current_line_blame, "[T]oggle [B]lame Line")
	map_l("td", gs.toggle_deleted, "[T]oggle [D]eleted")

	map(
		{
			"n",
			"v",
		},
		"<leader>hs",
		gs.stage_hunk,
		{
			desc = "[S]tage [H]unk",
			noremap = false,
		}
	)
	map(
		{
			"n",
			"v",
		},
		"<leader>hr",
		gs.reset_hunk,
		{
			desc = "[R]eset [H]unk",
			noremap = false,
		}
	)
	map(
		{
			"o",
			"x",
		},
		"ih",
		function() gs.select_hunk() end,
		{
			desc = "Select [i]n [h]unk",
		}
	)
	map(
		{
			"o",
			"x",
		},
		"ah",
		function() gs.select_hunk() end,
		{
			desc = "Select [a]round [h]unk",
		}
	)
end

--- @type LazySpec
local M = {
	"lewis6991/gitsigns.nvim",
}

M.event = {
	"BufNewFile",
	"BufReadPre",
}

M.opts = {
	current_line_blame = true,
	current_line_blame_formatter_nc = current_line_blame_formatter_nc,
	on_attach = on_attach,
	preview_config = {
		border = "rounded",
	},
}

M.config = true

return M
