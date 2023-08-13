local logger = require("config.util.logger")
local bind = require("config.lsp.util").bind
local util = require("config.util")

local lsp = vim.lsp.buf
local vim_diagnostic = vim.diagnostic

local LspKeymaps = {}

function LspKeymaps.on_attach(bufnr)
	util.mapL("d", vim_diagnostic.open_float, { desc = "Open [d]iagnostic float" })
	util.nmap("[d", function()
		vim_diagnostic.goto_prev({ float = false })
		util.scroll_center()
	end, { desc = "Goto previous [d]iagnostic issue" })
	util.nmap("]d", function()
		vim_diagnostic.goto_next({ float = false })
		util.scroll_center()
	end, { desc = "Goto next [d]iagnostic issue" })

	-- bind(bufnr,"ca", lsp.code_action, "[C]ode [a]ction")
	bind(bufnr, "<C-g>", lsp.signature_help, "Show signature help")
	bind(bufnr, "<leader>gD", lsp.declaration, "Show [d]eclaration")
	bind(bufnr, "<leader>rn", lsp.rename, "[R]ename variable")
	bind(bufnr, "<leader>wa", lsp.add_workspace_folder, "[A]dd [w]orkspace folder")
	bind(
		bufnr,
		"<leader>wl",
		function() logger.info(vim.inspect(lsp.list_workspace_folders())) end,
		"[L]ist [w]orkspace folders"
	)
	bind(bufnr, "<leader>wr", lsp.remove_workspace_folder, "[R]emove [w]orkspace folder")
	bind(bufnr, "K", lsp.hover, "Show hover")
	bind(bufnr, "gD", function()
		lsp.definition()
		util.scroll_center()
	end, "Show [d]efinition")
	bind(bufnr, "gR", function()
		lsp.references()
		util.scroll_center()
	end, "[G]et [r]eferences")
	bind(bufnr, "gY", lsp.type_definition, "Show t[y]pe definition")
	bind(bufnr, "gI", lsp.implementation, "Show [i]mplementation")
end

return LspKeymaps
