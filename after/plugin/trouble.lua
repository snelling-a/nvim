local utils = require("utils")

local function bind(target, source, desc)
	return utils.nmap(
		target,
		function() vim.cmd.TroubleToggle(source) end,
		{ expr = false, desc = desc }
		-- utils.tbl_extend_force({ expr = false }, desc)
	)
end

require("trouble").setup({ mode = "workspace_diagnostics", auto_close = true, use_diagnostic_signs = true })

bind("<leader>xx", nil, "Toggle trouble")
bind("<leader>xw", "workspace_diagnostics", "Toggle trouble for [w]orspace")
bind("<leader>xd", "document_diagnostics", "Toggle trouble for [d]ocument")
bind("<leader>xl", "loclist", "Toggle trouble [l]oclist")
bind("<leader>xq", "quickfix", "Toggle trouble [q]uickfix")
bind("gR", "lsp_references", "Toggle trouble for LSP [R]eference")
