vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })

require("gitsigns").setup({
	signs_staged_enable = true,
	attach_to_untracked = true,
	current_line_blame = true,
	on_attach = function(bufnr)
		local gs = require("gitsigns")

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		map("n", "]c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true })
			else
				gs.nav_hunk("next")
			end
		end, { desc = "Next hunk" })

		map("n", "[c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				gs.nav_hunk("prev")
			end
		end, { desc = "Previous hunk" })

		map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
		map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
		map("v", "<leader>hs", function()
			gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "Stage hunk" })
		map("v", "<leader>hr", function()
			gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "Reset hunk" })
		map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
		map("n", "<leader>hu", gs.stage_hunk, { desc = "Unstage hunk" })
		map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
		map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
		map("n", "<leader>hb", function()
			gs.blame_line({ full = true })
		end, { desc = "Blame line" })
		map("n", "<leader>hd", gs.diffthis, { desc = "Diff this" })
		map("n", "<leader>hD", function()
			gs.diffthis("~")
		end, { desc = "Diff this ~" })
		map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle line blame" })
		map("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle deleted" })

		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
	end,
})
