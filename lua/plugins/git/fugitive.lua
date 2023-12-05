local Git = vim.cmd.Git

---@param ev Ev
local function set_fugitive_keymaps(ev)
	if vim.bo.ft ~= "fugitive" then
		return
	end

	local function map_l(lhs, rhs, desc)
		return require("keymap").leader(lhs, rhs, {
			buffer = ev.buf,
			desc = desc,
		})
	end

	map_l("p", function()
		Git("push")
	end, "Git [p]ush")
	map_l("P", function()
		Git("pull --rebase")
	end, "Git [P]ull")
	map_l("t", function()
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

M.keys = {
	{
		"<leader>gs",
		function()
			Git({ mods = { vertical = true } })
		end,
		desc = "[G]it [s]tatus",
	},
}

function M.config()
	vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
		callback = set_fugitive_keymaps,
		desc = "Set fugitive keymaps",
		group = require("autocmd").augroup("Fugitive"),
		pattern = "*",
	})
end

return M
