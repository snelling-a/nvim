vim.diagnostic.config({
	jump = {
		on_jump = function()
			vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
		end,
	},
	severity_sort = true,
	signs = function()
		return {
			text = {
				[vim.diagnostic.severity.ERROR] = " ",
				[vim.diagnostic.severity.HINT] = " ",
				[vim.diagnostic.severity.INFO] = " ",
				[vim.diagnostic.severity.WARN] = "󱈸",
			},
		}
	end,
	underline = { severity = { min = vim.diagnostic.severity.HINT, max = vim.diagnostic.severity.ERROR } },
	update_in_insert = false,
	virtual_lines = false,
	virtual_text = {
		current_line = true,
		severity = { min = vim.diagnostic.severity.ERROR, max = vim.diagnostic.severity.ERROR },
	},
})

vim.keymap.set({ "n" }, "<leader>td", function()
	local is_enabled = vim.diagnostic.is_enabled()

	vim.diagnostic.enable(not is_enabled)
	vim.notify(("Diagnostics %s"):format(is_enabled and "disabled" or "enabled"))
end, { desc = "[T]oggle [D]iagnostics" })
