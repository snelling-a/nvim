local icons = require("config.ui.icons").dap

local M = { "mfussenegger/nvim-dap" }

M.dependencies = {
	"rcarriga/nvim-dap-ui",
	"theHamsta/nvim-dap-virtual-text",
	"williamboman/mason.nvim",
	{ "jay-babu/mason-nvim-dap.nvim", opts = { automatic_setup = true } },
}

function M.config()
	local dap = require("dap")
	local dapui = require("dapui")

	for name, sign in pairs(icons) do
		vim.fn.sign_define("Dap" .. name, { text = sign })
	end

	dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
	dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
	dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
end

return M
