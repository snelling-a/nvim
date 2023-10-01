--- @type LazySpec
local M = {
	"folke/trouble.nvim",
}

M.cmd = {
	"Trouble",
	"TroubleToggle",
}

M.opts = {
	auto_close = true,
	mode = "workspace_diagnostics",
	use_diagnostic_signs = true,
}

---@diagnostic disable-next-line: assign-type-mismatch
function M.keys()
	local trouble_toggle = require("trouble").toggle

	return {
		{
			"<leader>xx",
			function() trouble_toggle(nil) end,
			desc = "Toggle trouble",
		},
		{
			"<leader>xw",
			function() trouble_toggle("workspace_diagnostics") end,
			desc = "Toggle trouble for [w]orspace",
		},
		{
			"<leader>xd",
			function() trouble_toggle("document_diagnostics") end,
			desc = "Toggle trouble for [d]ocument",
		},
		{
			"<leader>xl",
			function() trouble_toggle("loclist") end,
			desc = "Toggle trouble [l]oclist",
		},
		{
			"<leader>xq",
			function() trouble_toggle("quickfix") end,
			desc = "Toggle trouble [q]uickfix",
		},
		{
			"<leader>gR",
			function() trouble_toggle("lsp_references") end,
			desc = "Toggle trouble for LSP [R]eference",
		},
	}
end

return M
