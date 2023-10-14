local ft = require("config.util.constants").javascript_typescript

--- @type LazySpec
local M = {
	"mxsdev/nvim-dap-vscode-js",
}

M.dependencies = {
	{
		"microsoft/vscode-js-debug",
		build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
		ft = ft,
	},
}

M.ft = ft

M.opts = {
	debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
	adapters = {
		"pwa-node",
		"pwa-chrome",
		"pwa-msedge",
		"node-terminal",
		"pwa-extensionHost",
	},
}

return M
