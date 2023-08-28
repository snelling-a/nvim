local Icons = require("config.ui.icons").progress

local M = { "williamboman/mason.nvim" }

M.build = ":MasonUpdate"

M.opts = {
	ui = {
		border = "rounded",
		icons = {
			package_installed = Icons.done,
			package_pending = Icons.pending,
			package_uninstalled = Icons.trash,
		},
	},
}

M.config = true

return M
