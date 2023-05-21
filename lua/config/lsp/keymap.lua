local logger = require("config.util.logger")
local util = require("config.util")

local lsp = vim.lsp.buf

local M = {}

function M.on_attach(bufnr)
	local function bind(target, source, desc)
		local opts = { buffer = bufnr, desc = desc }

		return util.nmap(target, source, opts)
	end

	bind("<C-g>", lsp.signature_help, "Show signature help")
	bind("<leader>D", lsp.type_definition, "Show type [d]efinition")
	-- bind("ca", lsp.code_action, "[C]ode [a]ction")
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
		util.scroll_center()
	end, "Show [d]efinition")
	bind("gi", lsp.implementation, "Show [i]mplementation")
	bind("gr", function()
		lsp.references()
		util.scroll_center()
	end, "[G]et [r]eferences")
end

return M
