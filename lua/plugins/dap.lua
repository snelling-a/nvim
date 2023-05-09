local icons = require("config.ui.icons").dap

local M = { "mfussenegger/nvim-dap" }

M.dependencies = {
	"rcarriga/nvim-dap-ui",
	"theHamsta/nvim-dap-virtual-text",
	"williamboman/mason.nvim",
	{
		"David-Kunz/jester",
		keys = {
			{ "<leader>djt", function() require("jester").debug() end, desc = "DAP Jester debug test" },
			{ "<leader>djf", function() require("jester").debug_file() end, desc = "DAP Jester debug file" },
			{ "<leader>djr", function() require("jester").debug_last() end, desc = "DAP Jester rerun debug" },
			{ "<leader>djT", function() require("jester").run() end, desc = "DAP Jester run test" },
			{ "<leader>djF", function() require("jester").run_file() end, desc = "DAP Jester run file" },
			{ "<leader>djR", function() require("jester").run_last() end, desc = "DAP Jester rerun test" },
		},
	},
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
	{
		"ofirgall/goto-breakpoints.nvim",
		keys = {
			{ "]b", function() require("goto-breakpoints").next() end, desc = "Go to next breakpoint" },
			{ "[b", function() require("goto-breakpoints").prev() end, "Go to previous breakpoint" },
		},
	},
}

}

function M.config()
	local dap = require("dap")
	local dapui = require("dapui")

	for name, sign in pairs(icons) do
		vim.fn.sign_define("Dap" .. name, { text = sign })
	end

	for _, language in ipairs({ "typescript", "javascript" }) do
		dap.configurations[language] = {
			{
				name = "Debug Jest Unit Tests (default)",
				type = "pwa-node",
				request = "launch",
				runtimeArgs = {
					"./node_modules/jest/bin/jest.js",
					"--runInBand",
				},
				cwd = "${workspaceFolder}",
				console = "integratedTerminal",
				internalConsoleOptions = "neverOpen",
			},
			{
				name = "Attach to running process (default)",
				type = "pwa-node",
				request = "attach",
				processId = require("dap.utils").pick_process,
				cwd = "${workspaceFolder}",
			},
		}
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
