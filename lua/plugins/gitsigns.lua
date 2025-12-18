vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })

require("gitsigns").setup({
	attach_to_untracked = true,
	current_line_blame = true,
	gh = true,
	signs_staged_enable = true,
	status_formatter = function(status)
		local parts = { "  " .. (status.head == "" and "detached HEAD" or status.head) }
		for _, s in ipairs({
			{ "added", "Added", " " },
			{ "changed", "Changed", " " },
			{ "removed", "Removed", " " },
		}) do
			---@type integer?
			local count = status[s[1]]
			if count and count > 0 then
				parts[#parts + 1] = ("%%#%s#%s%d"):format(s[2], s[3], count)
			end
		end
		return table.concat(parts, " ") .. "%##"
	end,
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
				---@diagnostic disable-next-line: param-type-mismatch
				gs.nav_hunk("next")
			end
		end, { desc = "Next hunk" })

		map("n", "[c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				---@diagnostic disable-next-line: param-type-mismatch
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
			---@diagnostic disable-next-line: param-type-mismatch
			gs.diffthis("~")
		end, { desc = "Diff this ~" })
		map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle line blame" })
		map("n", "<leader>td", gs.preview_hunk_inline, { desc = "Preview hunk inline" })

		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
	end,
})
