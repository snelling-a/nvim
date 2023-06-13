local Trouble = { "folke/trouble.nvim" }

Trouble.keys = {
	{ "<leader>xx", function() vim.cmd.TroubleToggle(nil) end, desc = "Toggle trouble" },
	{
		"<leader>xw",
		function() vim.cmd.TroubleToggle("workspace_diagnostics") end,
		desc = "Toggle trouble for [w]orspace",
	},
	{
		"<leader>xd",
		function() vim.cmd.TroubleToggle("document_diagnostics") end,
		desc = "Toggle trouble for [d]ocument",
	},
	{ "<leader>xl", function() vim.cmd.TroubleToggle("loclist") end, desc = "Toggle trouble [l]oclist" },
	{ "<leader>xq", function() vim.cmd.TroubleToggle("quickfix") end, desc = "Toggle trouble [q]uickfix" },
	{
		"<leader>gR",
		function() vim.cmd.TroubleToggle("lsp_references") end,
		desc = "Toggle trouble for LSP [R]eference",
	},
}

Trouble.opts = { auto_close = true, mode = "workspace_diagnostics", use_diagnostic_signs = true }

return Trouble
