local Icons = require("config.ui.icons")
local Statusline = require("config.ui.statusline")

local diagnostics = {
	{ "Error", Icons.diagnostics.Error, "DiagnosticErrorStatus" },
	{ "Warn", Icons.diagnostics.Warn, "DiagnosticWarnStatus" },
	{ "Hint", Icons.diagnostics.Hint, "DiagnosticHintStatus" },
	{ "Info", Icons.diagnostics.Info, "DiagnosticInfoStatus" },
}

local function get_diagnostics(active)
	local status = {}

	for _, attrs in ipairs(diagnostics) do
		local n = vim.diagnostic.get(0, { severity = attrs[1] })
		if #n > 0 then
			table.insert(status, ("%s %s %d"):format(Statusline.hl(attrs[3], active), attrs[2], #n))
		end
	end

	return status
end

local function get_lsp_names()
	local names = {}
	local attached = vim.lsp.get_clients({ bufnr = 0 })

	for _, c in ipairs(attached) do
		names[#names + 1] = c.name
	end

	return names
end

local function get_text(active)
	local text = ""
	local names = get_lsp_names()

	if #names > 0 then
		text = Statusline.hl("LspName", active) .. table.concat(names, ",")
	end

	return text
end

local M = {}

function M.hl_definitions()
	local api = vim.api
	local bg = Statusline.get_hl("StatusLine").bg

	for _, attrs in ipairs(diagnostics) do
		local fg = Statusline.get_hl("Diagnostic" .. attrs[1]).fg
		api.nvim_set_hl(0, attrs[3], { fg = fg, bg = bg })
	end

	local lsp_fg = Statusline.get_hl("User8")

	api.nvim_set_hl(0, "LspName", { fg = lsp_fg.fg, bg = bg })
end

function M.status(active)
	local status = get_diagnostics(active)

	local text = get_text(active)

	return text .. " " .. table.concat(status, " ")
end

return M
