local api = vim.api
local git = vim.cmd.Git

local function set_fugitive_keymaps()
	if vim.bo.ft ~= "fugitive" then
		return
	end

	local fzf = require("fzf-lua")

	local bufnr = api.nvim_get_current_buf()

	local function mapLeader(lhs, rhs, desc)
		return require("config.util").mapL(lhs, rhs, {
			buffer = bufnr,
			desc = desc,
		})
	end

	mapLeader("p", function() git("push") end, "Git [p]ush")
	mapLeader("P", function()
		git({
			"pull",
			"--rebase",
		})
	end, "Git [P]ull")
	mapLeader("t", function()
		git({
			"push -u origin",
		})
	end, "Push [t]o origin")
	mapLeader("gb", fzf.git_branches, "View [g]it [b]ranches")
	mapLeader("gc", fzf.git_commits, "View [g]it [c]ommits")
	mapLeader("gst", fzf.git_stash, "View [g]it [st]ash")
end

local M = {
	"tpope/vim-fugitive",
}

M.cmd = {
	"G",
	"Git",
	"Gvdiffsplit",
}

M.keys = {
	{ "<leader>gs", git, desc = "[G]it [s]tatus" },
}

function M.config()
	api.nvim_create_autocmd("BufWinEnter", {
		callback = function() set_fugitive_keymaps() end,
		desc = "Set fugitive keymaps",
		group = require("config.util").augroup("Fugitive"),
		pattern = "*",
	})
end

return M
