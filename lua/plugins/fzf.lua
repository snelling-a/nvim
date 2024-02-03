---@type LazySpec
local M = { "ibhagwan/fzf-lua" }

M.cmd = { "FzfLua", "GH" }

M.dependencies = { "nvim-tree/nvim-web-devicons" }

M.keys = {
	"<leader>ff",
	"<leader>fd",
	"<leader><space>",
	"<leader><tab>",
	"<leader>b",
	"<leader>fh",
	"<leader>qf",
	"?",
	"''",
	'""',
}

M.opts = {
	buffers = { cwd_only = true },
	files = {
		previewer = "bat",
		fd_opts = "--color=never --type f --hidden --follow --exclude .git --exclude node_modules",
		fzf_opts = { ["--history"] = ("%s/fzf-lua-files-history"):format(vim.fn.stdpath("data")) },
	},
	grep = {
		fzf_opts = { ["--history"] = ("%s/fzf-lua-grep-history"):format(vim.fn.stdpath("data")) },
	},
	keymap = {
		fzf = { ["alt-a"] = "select-all+accept" },
	},
	oldfiles = { cwd_only = true },
}

function M.config(_, opts)
	local fzf_lua = require("fzf-lua")

	fzf_lua.setup(opts)

	local Keymap = require("keymap")
	local leader = Keymap.leader
	local map = Keymap.nmap

	leader(".", fzf_lua.resume, { desc = "Resume last fzf query" })
	leader("<space>", fzf_lua.builtin, { desc = "Open builtins" })
	leader("<tab>", fzf_lua.keymaps, { desc = "Show keymaps" })
	leader("b", fzf_lua.buffers, { desc = "Show [b]uffers" })
	leader("fd", fzf_lua.live_grep, { desc = "Live grep" })
	leader("ff", fzf_lua.files, { desc = "[F]ind [f]iles" })
	leader("fh", fzf_lua.help_tags, { desc = "[F]ind [h]elp" })
	leader("ll", fzf_lua.loclist_stack, { desc = "Open [l]ocation [l]ist stack" })
	leader("qf", fzf_lua.quickfix_stack, { desc = "Open [q]uick[f]ix stack" })
	map("''", fzf_lua.marks, { desc = "View marks" })
	map("?", fzf_lua.blines, { desc = "Search current buffer" })
	map('""', fzf_lua.registers, { desc = "View registers" })

	vim.api.nvim_create_autocmd({ "VimResized" }, {
		callback = fzf_lua.redraw,
		desc = "Resize FzfLua when window resizes",
		group = require("autocmd").augroup("FzfLuaResize"),
		pattern = "*",
	})
end

return M
