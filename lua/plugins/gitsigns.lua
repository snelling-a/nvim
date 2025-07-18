---@type LazySpec
return {
	"lewis6991/gitsigns.nvim",
	event = { "LazyFile" },
	config = function()
		local gitsigns = require("gitsigns")
		local git_icons = require("icons").gitsigns

		---@diagnostic disable-next-line: missing-fields
		gitsigns.setup({
			current_line_blame = true,
			on_attach = function(bufnr)
				local map = require("user.keymap.util").map("Gitsigns")
				local next_hunk_repeat, prev_hunk_repeat =
					require("nvim-treesitter.textobjects.repeatable_move").make_repeatable_move_pair(
						gitsigns.nav_hunk,
						gitsigns.nav_hunk
					)

				map({ "n" }, "]h", function()
					if vim.wo.diff then
						vim.cmd.normal({ "]h", bang = true })
					else
						next_hunk_repeat("next")
					end
				end, { buffer = bufnr, desc = "Next Hunk" })

				map({ "n" }, "[h", function()
					if vim.wo.diff then
						vim.cmd.normal({ "[h", bang = true })
					else
						prev_hunk_repeat("prev")
					end
				end, { buffer = bufnr, desc = "Previous Hunk" })

				map({ "n" }, "<leader>hs", gitsigns.stage_hunk, { buffer = bufnr, desc = "[S]tage [H]unk" })
				map({ "n" }, "<leader>hr", gitsigns.reset_hunk, { buffer = bufnr, desc = "[R]eset [H]unk" })
				map({ "v" }, "<leader>hs", function()
					gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { buffer = bufnr, desc = "[S]tage [H]unk" })
				map({ "v" }, "<leader>hr", function()
					gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { buffer = bufnr, desc = "[R]eset [H]unk" })
				map({ "n" }, "<leader>hS", gitsigns.stage_buffer, { buffer = bufnr, desc = "[S]tage Buffer" })
				map({ "n" }, "<leader>hR", gitsigns.reset_buffer, { buffer = bufnr, desc = "[R]eset Buffer" })
				map({ "n" }, "<leader>hp", gitsigns.preview_hunk, { buffer = bufnr, desc = "[P]review [H]unk" })
				map({ "n" }, "<leader>hb", gitsigns.blame, { buffer = bufnr, desc = "[B]lame Line" })
				map(
					{ "n" },
					"<leader>tb",
					gitsigns.toggle_current_line_blame,
					{ buffer = bufnr, desc = "[T]oggle Current Line [B]lame" }
				)
				map({ "n" }, "<leader>hd", function()
					gitsigns.diffthis("~")
				end, { buffer = bufnr, desc = "[D]iff This" })
				map(
					{ "o", "x" },
					"ih",
					":<C-U>Gitsigns select_hunk<CR>",
					{ buffer = bufnr, desc = "[H]unk Text Object" }
				)
			end,
			attach_to_untracked = true,
			signs = git_icons,
			signs_staged = git_icons,
		} --[[@as Gitsigns.Config]])
	end,
}
