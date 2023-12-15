---@type LazySpec
local M = { "folke/trouble.nvim" }

M.cmd = { "TroubleToggle", "Trouble" }

M.event = { "LspAttach" }

M.opts = { auto_close = true, use_diagnostic_signs = true }

---@diagnostic disable-next-line: assign-type-mismatch
function M.keys()
	local trouble_toggle = require("trouble").toggle

	return {
		{
			"<leader>xx",
			function()
				trouble_toggle()
			end,
			desc = "Toggle trouble",
		},
		{
			"<leader>xw",
			function()
				trouble_toggle("workspace_diagnostics")
			end,
			desc = "Toggle trouble for [w]orspace",
		},
		{
			"<leader>xd",
			function()
				trouble_toggle("document_diagnostics")
			end,
			desc = "Toggle trouble for [d]ocument",
		},
	}
end

return M
