local formatting = require("config.lsp.formatting")
local logger = require("config.util.logger")
local util = require("config.util")

local diagnostic = vim.diagnostic
local lsp = vim.lsp.buf

local M = {}

function M.on_attach(bufnr)
	util.nmap("<leader>d", diagnostic.open_float, { desc = "Open [d]iagnostic float" })
	util.nmap("[d", function()
		diagnostic.goto_prev({ float = false })
		util.scroll_center()
	end, { desc = "Goto previous [d]iagnostic issue" })
	util.nmap("]d", function()
		diagnostic.goto_next({ float = false })
		util.scroll_center()
	end, { desc = "Goto next [d]iagnostic issue" })
	util.nmap("<leader>q", diagnostic.setloclist)

	local function bind(target, source, desc)
		local opts = { buffer = bufnr, desc = desc }

		return util.nmap(target, source, opts)
	end

	bind("<C-g>", lsp.signature_help, "Show signature help")
	bind("<leader>D", lsp.type_definition, "Show type [d]efinition")
	bind("<leader>ca", lsp.code_action, "[C]ode [a]ction")
	bind("<leader>f", function() formatting.format() end, "[F]ormat the current buffer")
	bind("<leader>tf", function() formatting.toggle() end, "[F]ormat the current buffer")
	bind("<leader>rn", lsp.rename, "[R]ename variable")
	bind("<leader>sw", function() vim.cmd("noautocmd write") end, "save without formatting")
	bind("<leader>wa", lsp.add_workspace_folder, "[A]dd [w]orkspace folder")
	bind(
		"<leader>wl",
		function() logger.info({ msg = vim.inspect(lsp.list_workspace_folders()) }) end,
		"[L]ist [w]orkspace folders"
	)
	bind("<leader>wr", lsp.remove_workspace_folder, "[R]emove [w]orkspace folder")
	bind("K", lsp.hover, "Show hover")
	bind("gD", lsp.declaration, { desc = "Show [d]eclaration" })
	bind("gd", function()
		lsp.definition()
		util.scroll_center()
	end, "Show [d]efinition")
	bind("gi", lsp.implementation, "Show [i]mplementation")
	bind("gr", function()
		lsp.references()
		util.scroll_center()
	end, "[G]et [r]eferences")
end

return M
