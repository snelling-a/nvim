local bind = require("config.lsp.util").bind
local Util = require("config.util")

local lsp = vim.lsp.buf
local vim_diagnostic = vim.diagnostic

local M = {}

--- @param bufnr integer
function M.on_attach(bufnr)
	local map_leader = Util.map_leader

	map_leader("d", vim_diagnostic.open_float, {
		desc = "Open [d]iagnostic float",
	})
	require("config.keymap.unimpaired").unimapired("d", {
		left = function()
			vim_diagnostic.goto_prev({
				float = false,
			})
			Util.scroll_center()
		end,
		right = function()
			vim_diagnostic.goto_next({
				float = false,
			})
			Util.scroll_center()
		end,
	}, {
		base = "Go to ",
		text = {
			left = "previous [d]iagnostic issue",
			right = "next [d]iagnostic issue",
		},
	})

	bind(bufnr, "<C-g>", lsp.signature_help, "Show signature help")
	bind(bufnr, "K", lsp.hover, "Show hover")
	bind(bufnr, "gI", lsp.implementation, "Show [i]mplementation")
	bind(bufnr, "gY", lsp.type_definition, "Show t[y]pe definition")
	bind(bufnr, "gd", function()
		lsp.definition()
		Util.scroll_center()
	end, "Show [d]efinition")
	bind(bufnr, "gr", function()
		lsp.references({ includeDeclaration = false })
		Util.scroll_center()
	end, "[G]et [r]eferences")
	map_leader("ca", lsp.code_action, { buffer = bufnr, desc = "[C]ode [a]ction" })
	map_leader("rn", lsp.rename, { buffer = bufnr, desc = "[R]ename variable" })
end

return M
