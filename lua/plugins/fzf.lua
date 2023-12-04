---@type LazySpec
local M = { "ibhagwan/fzf-lua" }

M.cmd = { "FzfLua", "GH" }

M.dependencies = { "nvim-tree/nvim-web-devicons" }

M.keys = {
	{
		"<leader>ff",
		function()
			require("fzf-lua").files()
		end,
		desc = "[F]ind [f]iles",
	},
	{
		"<leader>fd",
		function()
			require("fzf-lua").live_grep()
		end,
		desc = "Live grep",
	},
	{
		"<leader><space>",
		function()
			require("fzf-lua").builtin()
		end,
		desc = "Open builtins",
	},
	{
		"<leader><tab>",
		function()
			require("fzf-lua").keymaps()
		end,
		desc = "Show keymaps",
	},
	{
		"<leader>b",
		function()
			require("fzf-lua").buffers()
		end,
		desc = "Show [b]uffers",
	},
	{
		"<leader>fh",
		function()
			require("fzf-lua").help_tags()
		end,
		desc = "[F]ind [h]elp",
	},
	{
		"<leader>qf",
		function()
			require("fzf-lua").quickfix_stack()
		end,
		desc = "Open [q]uick[f]ix stack",
	},
	{
		"?",
		function()
			require("fzf-lua").blines()
		end,
		desc = "Search current buffer",
	},
	{
		"''",
		function()
			require("fzf-lua").marks()
		end,
		desc = "View marks",
	},
	{
		'""',
		function()
			require("fzf-lua").registers()
		end,
		desc = "View registers",
	},
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

	vim.api.nvim_create_autocmd({ "VimResized" }, {
		callback = fzf_lua.redraw,
		desc = "Resize FzfLua when window resizes",
		group = require("autocmd").augroup("FzfLuaResize"),
		pattern = "*",
	})
end

return M
