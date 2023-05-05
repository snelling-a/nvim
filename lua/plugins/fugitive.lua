local util = require("config.util")

local api = vim.api
local git = vim.cmd.Git

local function set_fugitive_keymaps()
	if vim.bo.ft ~= "fugitive" then
		return
	end

	local fzf = require("fzf-lua")

	local bufnr = api.nvim_get_current_buf()
	local opts = { buffer = bufnr }

	util.nmap("<leader>p", function() git("push") end, util.tbl_extend_force(opts, { desc = "Git [p]ush" }))
	util.nmap(
		"<leader>P",
		function() git({ "pull", "--rebase" }) end,
		util.tbl_extend_force(opts, { desc = "Git [P]ull" })
	)
	util.nmap(
		"<leader>t",
		function() git({ "push -u origin" }) end,
		util.tbl_extend_force(opts, { desc = "Push [t]o origin" })
	)
	util.nmap("<leader>gb", fzf.git_branches, { desc = "View [g]it [b]ranches" })
	util.nmap("<leader>gc", fzf.git_commits, { desc = "View [g]it [c]ommits" })
	util.nmap("<leader>gst", fzf.git_stash, { desc = "View [g]it [st]ash" })
end

local M = { "tpope/vim-fugitive" }

M.cmd = { "G", "Git" }

M.keys = { { "<leader>gs", vim.cmd.Git, desc = "[G]it [s]tatus" } }

function M.config()
	api.nvim_create_autocmd("BufWinEnter", {
		callback = function() set_fugitive_keymaps() end,
		desc = "Set fugitive keymaps",
		group = api.nvim_create_augroup("Fugitive", {}),
		pattern = "*",
	})
end

return M