---@type LazySpec
return {
	"isakbm/gitgraph.nvim",
	dependencies = { "sindrets/diffview.nvim" },
	keys = {
		{ "<leader>gk", desc = "GitGraph - Draw" },
	},
	opts = {
		git_cmd = "git",
		format = {
			timestamp = "%H:%M:%S %d-%m-%Y",
			fields = { "hash", "timestamp", "author", "branch_name", "tag" },
		},
		hooks = {
			-- Check diff of a commit
			on_select_commit = function(commit)
				vim.notify("DiffviewOpen " .. commit.hash .. "^!")
				vim.cmd(":DiffviewOpen " .. commit.hash .. "^!")
			end,
			-- Check diff from commit a -> commit b
			on_select_range_commit = function(from, to)
				vim.notify("DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
				vim.cmd(":DiffviewOpen " .. from.hash .. "~1.." .. to.hash)
			end,
		},
		symbols = {
			GCLD = "",
			GCLU = "",
			GCRD = "╭",
			GCRU = "",
			GFORKD = "",
			GFORKU = "",
			GHOR = "",
			GLRD = "",
			GLRDCL = "",
			GLRDCR = "",
			GLRU = "",
			GLRUCL = "",
			GLRUCR = "",
			GLUD = "",
			GLUDCD = "",
			GLUDCU = "",
			GRUD = "",
			GRUDCD = "",
			GRUDCU = "",
			GVER = "",
			commit = "",
			commit_end = "",
			merge_commit = "",
			merge_commit_end = "",
		},
	},
	config = function(_, opts)
		require("gitgraph").setup(opts)
		local map = require("user.keymap.util").map("GitGraph")

		map({ "n" }, "<leader>gk", function()
			require("gitgraph").draw({}, { all = true, max_count = 5000 })
		end, { desc = "GitGraph - Draw" })
	end,
}
