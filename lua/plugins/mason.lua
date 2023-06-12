local icons = require("config.ui.icons").progress

local Mason = { "williamboman/mason.nvim" }

Mason.build = ":MasonUpdate"

Mason.dependencies = {
	"jay-babu/mason-null-ls.nvim",
	{ "williamboman/mason-lspconfig.nvim", event = "LspAttach", opts = { automatic_installation = true } },
}

Mason.event = "BufAdd"

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

return Mason
