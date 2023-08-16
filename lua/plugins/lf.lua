local LF = {
	"lmburns/lf.nvim",
}

LF.dependencies = {
	"nvim-lua/plenary.nvim",
	"akinsho/toggleterm.nvim",
}

LF.lazy = false

LF.keys = {
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

LF.opts = {
	default_actions = {
		["<C-s>"] = "split",
	},
}

function LF.config(_, opts)
	vim.g.lf_netrw = 1

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

return LF
