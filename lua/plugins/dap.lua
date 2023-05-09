local icons = require("config.ui.icons").dap

local M = { "mfussenegger/nvim-dap" }

M.dependencies = {
	"rcarriga/nvim-dap-ui",
	"theHamsta/nvim-dap-virtual-text",
	"williamboman/mason.nvim",
	{ "jay-babu/mason-nvim-dap.nvim", opts = { automatic_setup = true } },
	{
		"mxsdev/nvim-dap-vscode-js",
		opts = function()
			return {
				debugger_path = require("mason-registry").get_package("js-debug-adapter"):get_install_path(),
				debugger_cmd = { "js-debug-adapter" },
				adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
			}
		end,
	},
}

function M.config()
	local dap = require("dap")
	local dapui = require("dapui")

	for name, sign in pairs(icons) do
		vim.fn.sign_define("Dap" .. name, { text = sign })
	end

	require("dap.ext.vscode").load_launchjs(nil, {
		["pwa-node"] = { "typescript" },
		["node"] = { "typescript" },
	})

	dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
	dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
	dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
end

return M
