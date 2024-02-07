---@type LazySpec
local M = { "lewis6991/gitsigns.nvim" }

M.event = require("util").constants.lazy_event

---@type Gitsigns.Config
---@diagnostic disable-next-line: missing-fields
M.opts = {
	current_line_blame = true,
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns
		local Keymap = require("keymap")

		local function map(lhs, rhs, opts, mode)
			opts = opts or {}

			opts.buffer = bufnr
			Keymap.leader(lhs, rhs, opts, mode)
		end

		Keymap.nmap("[h", function()
			if vim.wo.diff then
				return "[h"
			end
			vim.schedule(function()
				gs.prev_hunk()
			end)
			return "<Ignore>"
		end, { desc = "Prev [H]unk", expr = true })
		Keymap.nmap("]h", function()
			if vim.wo.diff then
				return "]h"
			end
			vim.schedule(function()
				gs.next_hunk()
			end)
			return "<Ignore>"
		end, { desc = "Next [H]unk", expr = true })

		map("hD", function()
			gs.diffthis("~")
		end, { desc = "[D]iff this buffer" })
		map("hP", gs.preview_hunk, { desc = "[P]review [H]unk" })
		map("hR", gs.reset_buffer, { desc = "[R]eset Buffer" })
		map("hS", gs.stage_buffer, { desc = "[S]tage Buffer" })
		map("hb", function()
			gs.blame_line({ full = true })
		end, { desc = "Show full [B]lame" })
		map("hd", gs.diffthis, { desc = "[D]iff this" })
		map("hp", gs.preview_hunk_inline, { desc = "[P]review [H]unk inline" })
		map("hr", function()
			gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "[R]eset [H]unk" }, "v")
		map("hr", gs.reset_hunk, { desc = "[R]eset [H]unk" })
		map("hs", function()
			gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "[S]tage [H]unk" }, "v")
		map("hs", gs.stage_hunk, { desc = "[S]tage [H]unk" })
		map("hu", gs.undo_stage_hunk, { desc = "[U]ndo [S]tage Hunk" })
		map("ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "[H]unk text object" }, { "o", "x" })
		map("tb", gs.toggle_current_line_blame, { desc = "[T]oggle current line blame" })
		map("td", gs.toggle_deleted)
	end,
	preview_config = { border = "rounded" },
	signs = require("ui.icons").gitsigns,
}

return M
