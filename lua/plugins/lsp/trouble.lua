---@type LazySpec
local M = { "folke/trouble.nvim" }

M.cmd = { "TroubleToggle", "Trouble" }

M.event = { "LspAttach" }

M.opts = { auto_close = true, use_diagnostic_signs = true }

---@diagnostic disable-next-line: assign-type-mismatch
function M.keys()
	local trouble_toggle = require("trouble").toggle
	local opts = { skip_groups = true, jump = true }
	local try = require("util").try

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
		{
			"[q",
			function()
				if require("trouble").is_open() then
					require("trouble").previous(opts)
				else
					try(vim.cmd.cprev, { msg = "No errors" })
				end
			end,
			desc = "Previous trouble/quickfix item",
		},
		{
			"]q",
			function()
				if require("trouble").is_open() then
					require("trouble").next(opts)
				else
					try(vim.cmd.next, { msg = "No errors" })
				end
			end,
			desc = "Next trouble/quickfix item",
		},
	}
end

return M
