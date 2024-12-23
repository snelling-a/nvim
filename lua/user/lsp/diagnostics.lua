---@class Diagnostics
local M = {}

---@type vim.diagnostic.Opts
local config = {
	float = {
		border = "rounded",
		header = "",
		prefix = function(diagnostic)
			if not diagnostic.source then
				return "", ""
			end
			local icon = Config.util.get_lsp_icon(diagnostic.source or "")
			local _, color = Config.util.get_file_icon()
			vim.api.nvim_set_hl(0, "DiagnosticFloatSource", { fg = color })

			return icon .. " ", "DiagnosticFloatSource"
		end,
		suffix = function(diagnostic)
			if not diagnostic.source then
				return "", ""
			end
			local severity = vim.diagnostic.severity[diagnostic.severity]
			local hl = Config.util.capitalize_first_letter(severity)
			local code = diagnostic.code and ": " .. diagnostic.code or ""

			return " [" .. diagnostic.source .. code .. "] ", "Diagnostic" .. hl
		end,
		source = "if_many",
	},
	jump = {
		float = true,
	},
	severity_sort = true,
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = Config.icons.diagnostics.Error,
			[vim.diagnostic.severity.HINT] = Config.icons.diagnostics.Hint,
			[vim.diagnostic.severity.INFO] = Config.icons.diagnostics.Info,
			[vim.diagnostic.severity.WARN] = Config.icons.diagnostics.Warn,
		},
	},
	underline = true,
	update_in_insert = true,
	virtual_text = false,
}

function M.on_attach()
	local opts = vim.deepcopy(config)

	vim.diagnostic.config(opts)
	local handlers = vim.diagnostic.handlers

	local orig_signs_handler = handlers.signs

	-- Override the built-in signs handler to aggregate signs
	handlers.signs = {
		show = function(ns, bufnr, diagnostics, signs_opts)
			-- Find the "worst" diagnostic per line
			local max_severity_per_line = {} --- @type table<integer,vim.Diagnostic>
			for _, d in pairs(diagnostics) do
				local m = max_severity_per_line[d.lnum]
				if not m or d.severity < m.severity then
					max_severity_per_line[d.lnum] = d
				end
			end

			-- Pass the filtered diagnostics (with our custom namespace) to
			-- the original handler
			local filtered_diagnostics = vim.tbl_values(max_severity_per_line)
			orig_signs_handler.show(ns, bufnr, filtered_diagnostics, signs_opts)
		end,

		hide = orig_signs_handler.hide,
	}
end

return M
