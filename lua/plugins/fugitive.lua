local Git = vim.cmd.Git

local function set_fugitive_keymaps()
	if vim.bo.ft ~= "fugitive" then
		return
	end

	local fzf = require("fzf-lua")

	local bufnr = vim.api.nvim_get_current_buf()

	local function map_l(lhs, rhs, desc)
		return require("config.util").map_leader(lhs, rhs, {
			buffer = bufnr,
			desc = desc,
		})
	end

	map_l("p", function() Git("push") end, "Git [p]ush")
	map_l("P", function() Git("pull --rebase") end, "Git [P]ull")
	map_l("t", function() Git("push -u origin") end, "Push [t]o origin")
	map_l("gb", fzf.git_branches, "View [g]it [b]ranches")
	map_l("gc", fzf.git_commits, "View [g]it [c]ommits")
	map_l("gst", fzf.git_stash, "View [g]it [st]ash")
end

--- @type LazySpec
local M = {
	"tpope/vim-fugitive",
}

M.cmd = {
	"G",
	"Git",
	"Gvdiffsplit",
}

M.keys = {
	---@diagnostic disable-next-line: missing-fields
	{
		"<leader>gs",
		Git,
		desc = "[G]it [s]tatus",
	},
}

function M.config()
	vim.api.nvim_create_autocmd("BufWinEnter", {
		callback = function() set_fugitive_keymaps() end,
		desc = "Set fugitive keymaps",
		group = require("config.util").augroup("Fugitive"),
		pattern = "*",
	})
end

return M
