local logger = require("config.util.logger")
local util = require("config.util")

local lsp = vim.lsp.buf
local vim_diagnostic = vim.diagnostic

local M = {}

function M.on_attach(bufnr)
	util.mapL("d", vim_diagnostic.open_float, { desc = "Open [d]iagnostic float" })
	util.nmap("[d", function()
		vim_diagnostic.goto_prev({ float = false })
		util.scroll_center()
	end, { desc = "Goto previous [d]iagnostic issue" })
	util.nmap("]d", function()
		vim_diagnostic.goto_next({ float = false })
		util.scroll_center()
	end, { desc = "Goto next [d]iagnostic issue" })

	local function bind(target, source, desc)
		local opts = { buffer = bufnr, desc = desc }

		return util.nmap(target, source, opts)
	end

	-- bind("ca", lsp.code_action, "[C]ode [a]ction")
	bind("<C-g>", lsp.signature_help, "Show signature help")
	bind("<leader>gD", lsp.declaration, { desc = "Show [d]eclaration" })
	bind("<leader>rn", lsp.rename, "[R]ename variable")
	bind("<leader>wa", lsp.add_workspace_folder, "[A]dd [w]orkspace folder")
	bind(
		"<leader>wl",
		function() logger.info(vim.inspect(lsp.list_workspace_folders())) end,
		"[L]ist [w]orkspace folders"
	)
	bind("<leader>wr", lsp.remove_workspace_folder, "[R]emove [w]orkspace folder")
	bind("K", lsp.hover, "Show hover")
	bind("gD", function()
		lsp.definition()
		util.scroll_center()
	end, "Show [d]efinition")
	bind("gR", function()
		lsp.references()
		util.scroll_center()
	end, "[G]et [r]eferences")
	bind("gY", lsp.type_definition, "Show t[y]pe definition")
	bind("gI", lsp.implementation, "Show [i]mplementation")
end

return M
