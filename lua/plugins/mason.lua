local icons = require("config.ui.icons").progress

local Mason = { "williamboman/mason.nvim" }

Mason.build = ":MasonUpdate"

Mason.dependencies = { "jay-babu/mason-null-ls.nvim" }

Mason.opts = {
	ui = {
		border = "rounded",
		icons = {
			package_installed = icons.done,
			package_pending = icons.pending,
			package_uninstalled = icons.trash,
		},
	},
}

Mason.config = true

return Mason
