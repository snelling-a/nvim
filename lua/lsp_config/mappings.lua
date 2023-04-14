local logger = require("utils.logger")
local utils = require("utils")
local format = require("lsp_config.formatting").lsp_formatting

local diagnostic = vim.diagnostic
local lsp = vim.lsp.buf

return function(bufnr)
	utils.nmap("<leader>d", diagnostic.open_float, { desc = "Open [d]iagnostic float" })
	utils.nmap("[d", function()
		diagnostic.goto_prev({ float = false })
		utils.scroll_center()
	end, { desc = "Goto previous [d]iagnostic issue" })
	utils.nmap("]d", function()
		diagnostic.goto_next({ float = false })
		utils.scroll_center()
	end, { desc = "Goto next [d]iagnostic issue" })
	utils.nmap("<leader>q", diagnostic.setloclist)

	local function bind(target, source, desc)
		local opts = { buffer = bufnr, desc = desc }

		return utils.nmap(target, source, opts)
	end

	bind("<C-g>", lsp.signature_help, "Show signature help")
	bind("<leader>D", lsp.type_definition, "Show type [d]efinition")
	bind("<leader>ca", lsp.code_action, "[C]ode [a]ction")
	bind("<leader>f", function() format() end, "[F]ormat the current buffer")
	bind("<leader>rn", lsp.rename, "[R]ename variable")
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
		utils.scroll_center()
	end, "Show [d]efinition")
	bind("gi", lsp.implementation, "Show [i]mplementation")
	bind("gr", function()
		lsp.references()
		utils.scroll_center()
	end, "[G]et [r]eferences")
end
