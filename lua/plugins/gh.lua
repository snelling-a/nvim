local GH = { "ldelossa/gh.nvim" }

GH.cmd = "GH"

GH.dependencies = { "ibhagwan/fzf-lua", { "ldelossa/litee.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } } }

GH.opts = { icon_set = "codicons", panel = { orientation = "left", panel_size = 30 } }

function GH.config(_, opts)
	require("litee.lib").setup({
		tree = { icon_set = "codicons" },
		panel = { orientation = "left", panel_size = 40 },
		notify = { enabled = false },
	})

	require("litee.gh").setup(opts)
end

return GH
