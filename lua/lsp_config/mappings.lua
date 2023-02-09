local nmap = require("utils").nmap

return function(bufnr)
	nmap("<leader>d", vim.diagnostic.open_float, { desc = "Open [d]iagnostic float" })
	nmap("[d", function() vim.diagnostic.goto_prev({ float = false }) end, { desc = "Goto previous diagnostic issue" })
	nmap("]d", function() vim.diagnostic.goto_next({ float = false }) end, { desc = "Goto next diagnostic issue" })
	nmap("<leader>q", vim.diagnostic.setloclist)

	-- Enable completion triggered by <c-x><c-o>
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

	local opts = { buffer = bufnr }

	nmap("gD", vim.lsp.buf.declaration, opts)
	nmap("gd", vim.lsp.buf.definition, opts, { desc = "Show [d]efinition" })
	nmap("K", vim.lsp.buf.hover, opts, { desc = "Show hover" })
	nmap("gi", vim.lsp.buf.implementation, opts, { desc = "Show [i]mplementation" })
	nmap("<C-k>", vim.lsp.buf.signature_help, opts, { desc = "Show signature help" })
	nmap("<leader>wa", vim.lsp.buf.add_workspace_folder, opts, { desc = "[A]dd [w]orkspace folder" })
	nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder, opts, { desc = "[R]emove [w]orkspace folder" })
	nmap(
		"<leader>wl",
		function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end,
		opts,
		{ desc = "[L]ist [w]orkspace folders" }
	)
	nmap("<leader>D", vim.lsp.buf.type_definition, opts, { desc = "Show type [d]efinition" })
	nmap("<leader>rn", vim.lsp.buf.rename, opts, { desc = "[R]ename variable" })
	nmap("<leader>ca", vim.lsp.buf.code_action, opts, { desc = "[C]ode [a]ction" })
	nmap("gr", vim.lsp.buf.references, opts, { desc = "[G]et [r]eferences" })
	nmap("<leader>f", function() vim.lsp.buf.format({ async = true }) end, opts, { desc = "[F]ormat buffer" })
end
