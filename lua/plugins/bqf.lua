local M = {
	"kevinhwang91/nvim-bqf",
}

M.ft = "qf"

M.opts = {
	filter = {
		fzf = {
			extra_opts = {
				"--bind",
				"ctrl-o:toggle-all",
				"--delimiter",
				"│",
			},
		},
	},
}

return M
