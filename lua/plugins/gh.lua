local M = {
	"ldelossa/gh.nvim",
}

M.cmd = "GH"

M.dependencies = {
	"ibhagwan/fzf-lua",
	{
		"ldelossa/litee.nvim",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
	},
}

M.opts = {
	icon_set = "codicons",
	panel = {
		orientation = "left",
		panel_size = 30,
	},
}

function M.config(_, opts)
	require("litee.lib").setup({
		tree = {
			icon_set = "codicons",
		},
		panel = {
			orientation = "left",
			panel_size = 40,
		},
		notify = {
			enabled = false,
		},
	})

	require("litee.gh").setup(opts)
end

return M
