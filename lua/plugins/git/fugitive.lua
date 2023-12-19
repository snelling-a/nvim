local Git = vim.cmd.Git
local desc = "[G]it [s]tatus"

---@param ev Ev
local function set_fugitive_keymaps(ev)
	if vim.bo.ft ~= "fugitive" then
		return
	end

	---@param lhs string
	---@param rhs function
	---@param desc string
	local function leader(lhs, rhs, leader_desc)
		return require("keymap").leader(lhs, rhs, {
			buffer = ev.buf,
			desc = leader_desc,
		})
	end

	leader("p", function()
		Git("push")
	end, "Git [p]ush")
	leader("P", function()
		Git("pull --rebase")
	end, "Git [P]ull")
	leader("t", function()
		Git("push -u origin")
	end, "Push [t]o origin")
end

---@type LazySpec
local M = { "tpope/vim-fugitive" }

M.cmd = {
	"G",
	"Git",
	"Gvdiffsplit",
}

M.keys = { "<leader>gs", desc = desc }

function M.config()
	require("keymap").nmap("<leader>gs", function()
		Git({ mods = { vertical = true } })
	end, { desc = desc })

	vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
		callback = set_fugitive_keymaps,
		desc = "Set fugitive keymaps",
		group = require("autocmd").augroup("Fugitive"),
		pattern = "*",
	})
end

return M
