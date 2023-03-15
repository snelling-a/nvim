local utils = require("utils")

return function(bufnr)
	utils.nmap("<leader>d", vim.diagnostic.open_float, { desc = "Open [d]iagnostic float" })
	utils.nmap("[d", function()
		vim.diagnostic.goto_prev({ float = false })
		utils.scroll_center()
	end, { desc = "Goto previous diagnostic issue" })
	utils.nmap("]d", function()
		vim.diagnostic.goto_next({ float = false })
		utils.scroll_center()
	end, { desc = "Goto next diagnostic issue" })
	utils.nmap("<leader>q", vim.diagnostic.setloclist)

	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	local opts = { buffer = bufnr }

	utils.nmap("gD", vim.lsp.buf.declaration, opts)
	utils.nmap("gd", function()
		vim.lsp.buf.definition()
		utils.scroll_center()
	end, opts, { desc = "Show [d]efinition" })
	utils.nmap("K", vim.lsp.buf.hover, opts, { desc = "Show hover" })
	utils.nmap("gi", vim.lsp.buf.implementation, opts, { desc = "Show [i]mplementation" })
	utils.nmap("<C-k>", vim.lsp.buf.signature_help, opts, { desc = "Show signature help" })
	utils.nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, opts, { desc = "[A]dd [w]orkspace folder" })
	utils.nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, opts, { desc = "[R]emove [w]orkspace folder" })
	utils.nmap(
		"<leader>wl",
		function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
		opts,
		{ desc = "[L]ist [w]orkspace folders" }
	)
	utils.nmap("<leader>D", vim.lsp.buf.type_definition, opts, { desc = "Show type [d]efinition" })
	utils.nmap("<leader>rn", vim.lsp.buf.rename, opts, { desc = "[R]ename variable" })
	utils.nmap("<leader>ca", vim.lsp.buf.code_action, opts, { desc = "[C]ode [a]ction" })
	utils.nmap("gr", function()
		vim.lsp.buf.references()
		utils.scroll_center()
	end, opts, { desc = "[G]et [r]eferences" })
	utils.nmap("<leader>f", function() vim.lsp.buf.format({ async = true }) end, opts, { desc = "[F]ormat buffer" })
end
