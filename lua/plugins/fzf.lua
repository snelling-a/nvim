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
		cwd_prompt = false,
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

	---@param lhs string
	---@param rhs function
	---@param desc string
	local function leader(lhs, rhs, desc)
		Keymap.leader(lhs, rhs, { desc = desc })
	end
	---@param lhs string
	---@param rhs function
	---@param desc string
	local function map(lhs, rhs, desc)
		Keymap.nmap(lhs, rhs, { desc = desc })
	end

	leader(".", fzf_lua.resume, "Resume last fzf query")
	leader("<space>", fzf_lua.builtin, "Open builtins")
	leader("<tab>", fzf_lua.keymaps, "Show keymaps")
	leader("b", fzf_lua.buffers, "Show [b]uffers")
	leader("fd", fzf_lua.live_grep, "Live grep")
	leader("ff", fzf_lua.files, "[F]ind [f]iles")
	leader("fh", fzf_lua.help_tags, "[F]ind [h]elp")
	leader("ll", fzf_lua.loclist_stack, "Open [l]ocation [l]ist stack")
	leader("qf", fzf_lua.quickfix_stack, "Open [q]uick[f]ix stack")
	map("''", fzf_lua.marks, "View marks")
	map("?", fzf_lua.blines, "Search current buffer")
	map('""', fzf_lua.registers, "View registers")

	vim.api.nvim_create_autocmd({ "VimResized" }, {
		callback = fzf_lua.redraw,
		desc = "Resize FzfLua when window resizes",
		group = require("autocmd").augroup("FzfLuaResize"),
		pattern = "*",
	})
end

return M
