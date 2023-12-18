---@type LazySpec
local M = { "lewis6991/gitsigns.nvim" }

M.event = require("util").constants.lazy_event

---@type Gitsigns.Config
---@diagnostic disable-next-line: missing-fields
M.opts = {
	current_line_blame = true,
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns

		---@param lhs string
		---@param rhs string|function
		---@param desc string
		---@param mode VimMode?
		local function map(lhs, rhs, desc, mode)
			require("keymap").map(mode or "n", lhs, rhs, { buffer = bufnr, desc = desc })
		end

		map("<leader>hD", function()
			gs.diffthis("~")
		end, "Diff This ~")
		map("<leader>hR", gs.reset_buffer, "Reset Buffer")
		map("<leader>hS", gs.stage_buffer, "Stage Buffer")
		map("<leader>hb", function()
			gs.blame_line({ full = true })
		end, "Blame Line")
		map("<leader>hd", gs.diffthis, "Diff This")
		map("<leader>hp", gs.preview_hunk, "Preview Hunk")
		map("<leader>hu", gs.undo_stage_hunk, "Undo Stage Hunk")
		map("[h", gs.prev_hunk, "Prev Hunk")
		map("]h", gs.next_hunk, "Next Hunk")
		map("<leader>hr", ":Gitsigns reset_hunk<CR>", "Reset Hunk", { "n", "v" })
		map("<leader>hs", ":Gitsigns stage_hunk<CR>", "Stage Hunk", { "n", "v" })
		map("ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk", { "n", "v" })
	end,
	preview_config = { border = "rounded" },
	signs = require("ui.icons").gitsigns,
}

return M
