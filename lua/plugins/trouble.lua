--- @type LazySpec
local M = {
	"folke/trouble.nvim",
}

M.keys = {
	---@diagnostic disable-next-line: missing-fields
	{
		"<leader>xx",
		function() vim.cmd.TroubleToggle(nil) end,
		desc = "Toggle trouble",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"<leader>xw",
		function() vim.cmd.TroubleToggle("workspace_diagnostics") end,
		desc = "Toggle trouble for [w]orspace",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"<leader>xd",
		function() vim.cmd.TroubleToggle("document_diagnostics") end,
		desc = "Toggle trouble for [d]ocument",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"<leader>xl",
		function() vim.cmd.TroubleToggle("loclist") end,
		desc = "Toggle trouble [l]oclist",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"<leader>xq",
		function() vim.cmd.TroubleToggle("quickfix") end,
		desc = "Toggle trouble [q]uickfix",
	},
	---@diagnostic disable-next-line: missing-fields
	{
		"<leader>gR",
		function() vim.cmd.TroubleToggle("lsp_references") end,
		desc = "Toggle trouble for LSP [R]eference",
	},
}

M.opts = {
	auto_close = true,
	mode = "workspace_diagnostics",
	use_diagnostic_signs = true,
}

return M
