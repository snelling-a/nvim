local telescope = require("telescope.builtin")
local utils = require("utils")

local api = vim.api
local git = vim.cmd.Git

utils.nmap("<leader>gs", git, { desc = "[G]it [s]tatus" })

local FugitiveGroup = api.nvim_create_augroup("Fugitive", {})

api.nvim_create_autocmd("BufWinEnter", {
	group = FugitiveGroup,
	pattern = "*",
	callback = function()
		if vim.bo.ft ~= "fugitive" then
			return
		end

		local bufnr = api.nvim_get_current_buf()
		local opts = { buffer = bufnr }

		utils.nmap("<leader>p", function() git("push") end, utils.tbl_extend_force(opts, { desc = "Git [p]ush" }))
		utils.nmap(
			"<leader>P",
			function() git({ "pull", "--rebase" }) end,
			utils.tbl_extend_force(opts, { desc = "Git [P]ull" })
		)
		utils.nmap(
			"<leader>t",
			function() git({ "push -u origin" }) end,
			utils.tbl_extend_force(opts, { desc = "Push [t]o origin" })
		)
		utils.nmap("<leader>gb", telescope.git_branches, { desc = "View [g]it [b]ranches" })
		utils.nmap("<leader>gc", telescope.git_commits, { desc = "View [g]it [c]ommits" })
		utils.nmap("<leader>gst", telescope.git_stash, { desc = "View [g]it [st]ash" })
	end,
})
