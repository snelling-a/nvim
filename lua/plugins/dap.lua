local icons = require("config.ui.icons").dap

--- @type LazySpec
local M = {
	"mfussenegger/nvim-dap",
}

M.dependencies = {
	{
		"theHamsta/nvim-dap-virtual-text",
		opts = {
			commented = true,
		},
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		opts = {
			automatic_setup = true,
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
		local hl = "Dap" .. name
		vim.fn.sign_define(hl, { text = sign, texthl = hl })
	end

	for _, language in ipairs(require("config.util.constants").javascript_typescript) do
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

-- M.enabled = false

return M
