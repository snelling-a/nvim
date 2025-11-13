---@type vim.diagnostic.Opts
local config = {
	float = {
		header = "",
		prefix = function(diagnostic)
			if not diagnostic.source then
				return "", ""
			end

			local icons = require("icons.util")
			local Icons = require("icons")

			local icon = Icons.servers[diagnostic.source:lower()]
			if
				vim.startswith(diagnostic.source, "ST")
				or vim.startswith(diagnostic.source, "QF")
				or vim.startswith(diagnostic.source, "QF")
			then
				icon = Icons.servers["staticcheck"]
			end
			local _, color = icons.get_file_icon()

			vim.api.nvim_set_hl(0, "DiagnosticFloatSource", { fg = color })

			return icon .. " ", "DiagnosticFloatSource"
		end,
		suffix = function(diagnostic)
			if not diagnostic.source then
				return "", ""
			end
			---@type vim.diagnostic.SeverityName
			local severity = vim.diagnostic.severity[diagnostic.severity]
			local hl = require("util").capitalize_first_letter(severity)
			local code = diagnostic.code and ": " .. diagnostic.code or ""

			return " [" .. diagnostic.source .. code .. "] ", "Diagnostic" .. hl
		end,
		source = "if_many",
	},
	jump = { float = true },
	severity_sort = true,
	signs = function()
		local icons = require("icons")

		---@type vim.diagnostic.Opts.Signs
		return {
			text = {
				[vim.diagnostic.severity.ERROR] = icons.diagnostics.Error,
				[vim.diagnostic.severity.HINT] = icons.diagnostics.Hint,
				[vim.diagnostic.severity.INFO] = icons.diagnostics.Info,
				[vim.diagnostic.severity.WARN] = icons.diagnostics.Warn,
			},
		}
	end,
	underline = true,
	update_in_insert = true,
}

vim.diagnostic.config(config)

local namespace = vim.api.nvim_create_namespace("nvim.diagnostics")

local orig_signs_handler = vim.diagnostic.handlers.signs

vim.diagnostic.handlers.signs = {
	show = function(_, bufnr, _, opts)
		local diagnostics = vim.diagnostic.get(bufnr)

		---@type table<number, vim.Diagnostic>
		local max_severity_per_line = {}
		for _, d in pairs(diagnostics) do
			local m = max_severity_per_line[d.lnum]
			if not m or d.severity < m.severity then
				max_severity_per_line[d.lnum] = d
			end
		end

		local filtered_diagnostics = vim.tbl_values(max_severity_per_line)
		orig_signs_handler.show(namespace, bufnr, filtered_diagnostics, opts)
	end,
	hide = function(_, bufnr)
		orig_signs_handler.hide(namespace, bufnr)
	end,
}

vim.api.nvim_create_user_command("DiagnosticLines", function(args)
	---@type boolean
	local is_enabled
	if args.bang then
		is_enabled = false
	else
		is_enabled = not vim.diagnostic.config().virtual_lines
	end

	vim.diagnostic.config({ jump = { float = not is_enabled }, virtual_lines = is_enabled })
end, { bang = true, desc = "Toggle diagnostic virtual_lines" })
