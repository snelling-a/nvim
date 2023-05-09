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
		"jbyuki/one-small-step-for-vimkind",
		keys = {
			{ "<F8>", function() require("dap").toggle_breakpoint() end, desc = "" },
			{ "<F9>", function() require("dap").continue() end, desc = "" },
			{ "<F10>", function() require("dap").step_over() end, desc = "" },
			{ "<S-F10>", function() require("dap").step_into() end, desc = "" },
			{ "<F12>", function() require("dap.ui.widgets").hover() end, desc = "" },
			{ "<F5>", function() require("osv").launch({ port = 8086 }) end, desc = "" },
		},
	},
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

M.keys = {
	{ "<F10>", function() require("dap").step_over() end, desc = "DAP step over" },
	{ "<F11>", function() require("dap").step_into() end, desc = "DAP step into" },
	{ "<F12>", function() require("dap").step_out() end, desc = "DAP step out" },
	{ "<F5>", function() require("dap").continue() end, desc = "DAP continue" },
	{
		"<leader>dB",
		function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end,
		desc = "DAP Breakpoint Condition",
	},
	{ "<Leader>db", function() require("dap").toggle_breakpoint() end, desc = "DAP toggle breakpoint" },
	{
		"<Leader>df",
		function()
			local widgets = require("dap.ui.widgets")
			widgets.centered_float(widgets.frames)
		end,
		desc = "DAP frames",
	},
	{ "<Leader>dh", function() require("dap.ui.widgets").hover() end, desc = "DAP hover" },
	{ "<Leader>dl", function() require("dap").run_last() end, desc = "DAP run last" },
	{ "<Leader>dp", function() require("dap.ui.widgets").preview() end, desc = "DAP preview" },
	{ "<Leader>dr", function() require("dap").repl.open() end, desc = "DAP open" },
	{
		"<Leader>ds",
		function()
			local widgets = require("dap.ui.widgets")
			widgets.centered_float(widgets.scopes)
		end,
		desc = "DAP scopes",
	},
	{
		"<Leader>lp",
		function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: ")) end,
		desc = "DAP input",
	},
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

	dap.configurations.lua = {
		{
			type = "nlua",
			request = "attach",
			name = "Attach to running Neovim instance",
		},
	}

	dap.adapters.nlua = function(callback, config)
		callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
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
