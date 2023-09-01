--- @type LazySpec
local M = {
	"lmburns/lf.nvim",
}

M.dependencies = {
	"nvim-lua/plenary.nvim",
	"akinsho/toggleterm.nvim",
}

M.lazy = false

M.keys = {
	{
		"<M-o>",
		vim.cmd.Lf,
		desc = "Open lf",
	},
	{
		"<M-u",
		desc = "Resize lf window",
	},
}

M.opts = {
	default_actions = {
		["<C-s>"] = "split",
	},
}

function M.config(_, opts)
	-- vim.g.lf_netrw = 1

	require("lf").setup(opts)

	vim.api.nvim_create_autocmd("User", {
		pattern = "LfTermEnter",
		callback = function(a)
			vim.api.nvim_buf_set_keymap(a.buf, "t", "q", "q", {
				nowait = true,
			})
		end,
	})
end

return M
