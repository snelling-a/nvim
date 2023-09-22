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
	local gs = package.loaded.gitsigns
	local opts = {
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
			left = "preview [c]hange (hunk)",
		},
	})
	Util.nmap(
		"]c",
		function()
			if vim.wo.diff then
				return "]c"
			end
			vim.schedule(function()
				gs.next_hunk()
				preview()
			end)
			return "<Ignore>"
		end,
		Util.tbl_extend_force(opts, {
			desc = "Next [H]unk",
		})
	)
	Util.nmap(
		"[c",
		function()
			if vim.wo.diff then
				return "[c"
			end
			vim.schedule(function()
				gs.prev_hunk()
				preview()
			end)
			return "<Ignore>"
		end,
		Util.tbl_extend_force(opts, {
			desc = "Previous [H]unk",
		})
	)
	Util.map(
		{
			"n",
			"v",
		},
		"<leader>hs",
		function() vim.cmd.Gitsigns("stage_hunk") end,
		{
			desc = "[S]tage [H]unk",
			noremap = false,
		}
	)
	Util.map(
		{
			"n",
			"v",
		},
		"<leader>hr",
		function() vim.cmd.Gitsigns("reset_hunk") end,
		{
			desc = "[R]eset [H]unk",
			noremap = false,
		}
	)
	Util.mapL("hq", function() vim.cmd.Gitsigns("setqflist") end, {
		desc = "Populate the [q]uickfix list with [h]unks",
	})
	Util.mapL("hS", gs.stage_buffer, {
		desc = "[S]tage Buffer",
	})
	Util.mapL("hu", gs.undo_stage_hunk, {
		desc = "[U]ndo Stage [H]unk",
	})
	Util.mapL("hR", gs.reset_buffer, {
		desc = "[R]eset Buffer",
	})
	Util.mapL("hp", gs.preview_hunk, {
		desc = "[P]review [H]unk",
	})
	Util.mapL("hb", function()
		gs.blame_line({
			full = true,
		})
	end, {
		desc = "[B]lame [L]ine",
	})
	Util.mapL("tb", gs.toggle_current_line_blame, {
		desc = "[T]oggle [B]lame Line",
	})
	Util.mapL("hd", gs.diffthis, {
		desc = "[D]iff this",
	})
	Util.mapL("hD", function() gs.diffthis("~") end, {
		desc = "[D]iff this",
	})
	Util.mapL("td", gs.toggle_deleted, {
		desc = "[T]oggle [D]eleted",
	})

	Util.map(
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
	Util.map(
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
