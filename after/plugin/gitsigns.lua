local utils = require("utils")

local function current_line_blame_formatter_nc(_, blame_info, _)
	if blame_info.committer == "Not Committed Yet" then
		return { { "", "None" } }
	end
end

local function on_attach(bufnr)
	local gs = package.loaded.gitsigns
	local opts = { buffer = bufnr, expr = true }

	utils.nmap("]c", function()
		if vim.wo.diff then
			return "]c"
		end
		vim.schedule(function()
			gs.next_hunk()
			utils.scroll_center()
		end)
		return "<Ignore>"
	end, utils.tbl_extend_force(opts, { desc = "Next [H]unk" }))
	utils.nmap("[c", function()
		if vim.wo.diff then
			return "[c"
		end
		vim.schedule(function()
			gs.prev_hunk()
			utils.scroll_center()
		end)
		return "<Ignore>"
	end, utils.tbl_extend_force(opts, { desc = "Previous [H]unk" }))
	utils.map(
		{ "n", "v" },
		"<leader>hs",
		function() vim.cmd.Gitsigns("stage_hunk") end,
		{ desc = "[S]tage [H]unk", noremap = false }
	)
	utils.map(
		{ "n", "v" },
		"<leader>hr",
		function() vim.cmd.Gitsigns("reset_hunk") end,
		{ desc = "[R]eset [H]unk", noremap = false }
	)
	utils.nmap("<leader>hS", gs.stage_buffer, { desc = "[S]tage Buffer" })
	utils.nmap("<leader>hu", gs.undo_stage_hunk, { desc = "[U]ndo Stage [H]unk" })
	utils.nmap("<leader>hR", gs.reset_buffer, { desc = "[R]eset Buffer" })
	utils.nmap("<leader>hp", gs.preview_hunk, { desc = "[P]review [H]unk" })
	utils.nmap("<leader>hb", function() gs.blame_line({ full = true }) end, { desc = "[B]lame [L]ine" })
	utils.nmap("<leader>tb", gs.toggle_current_line_blame, { desc = "[T]oggle [B]lame Line" })
	utils.nmap("<leader>hd", gs.diffthis, { desc = "[D]iff this" })
	utils.nmap("<leader>hD", function() gs.diffthis("~") end, { desc = "[D]iff this" })
	utils.nmap("<leader>td", gs.toggle_deleted, { desc = "[T]oggle [D]eleted" })

	utils.map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select [i]n [h]unk" })
	utils.map({ "o", "x" }, "ah", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select [a]round [h]unk" })
end

require("gitsigns").setup({
	numhl = true,
	current_line_blame = true,
	current_line_blame_formatter_nc = current_line_blame_formatter_nc,
	preview_config = { border = "rounded" },
	on_attach = on_attach,
})
