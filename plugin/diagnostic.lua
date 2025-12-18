local signs = {
	text = {
		[vim.diagnostic.severity.ERROR] = " ",
		[vim.diagnostic.severity.HINT] = " ",
		[vim.diagnostic.severity.INFO] = " ",
		[vim.diagnostic.severity.WARN] = "󱈸",
	},
}

vim.diagnostic.config({
	float = {
		header = "",
		suffix = function(diagnostic)
			if not diagnostic.source then
				return "", ""
			end
			---@type vim.diagnostic.SeverityName
			local severity = vim.diagnostic.severity[diagnostic.severity]
			local hl = "Diagnostic" .. string.sub(severity, 1, 1) .. string.lower(string.sub(severity, 2))
			local code = diagnostic.code and ": " .. diagnostic.code or ""
			return " [" .. diagnostic.source .. code .. "]", hl
		end,
	},
	jump = {
		on_jump = function()
			vim.diagnostic.open_float(nil, { focus = false, scope = "cursor" })
		end,
	},
	severity_sort = true,
	signs = signs,
	status = signs,
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

--- Jump to the next or previous diagnostic
---@param count 1|-1 The number of diagnostics to jump
---@param severity? vim.diagnostic.Severity See |diagnostic-severity|.
---@return fun():vim.Diagnostic?
local function diagnostic_goto(count, severity)
	return function()
		vim.diagnostic.jump({ count = count, severity = severity })
	end
end

vim.keymap.set({ "n" }, "[d", diagnostic_goto(-1), { desc = "Prev Diagnostic" })
vim.keymap.set({ "n" }, "]d", diagnostic_goto(1), { desc = "Next Diagnostic" })
vim.keymap.set({ "n" }, "[e", diagnostic_goto(-1, vim.diagnostic.severity.ERROR), { desc = "Prev Error" })
vim.keymap.set({ "n" }, "]e", diagnostic_goto(1, vim.diagnostic.severity.ERROR), { desc = "Next Error" })
vim.keymap.set({ "n" }, "[w", diagnostic_goto(-1, vim.diagnostic.severity.WARN), { desc = "Prev Warning" })
vim.keymap.set({ "n" }, "]w", diagnostic_goto(1, vim.diagnostic.severity.WARN), { desc = "Next Warning" })
