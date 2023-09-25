local Icons = require("config.ui.icons")
local Statusline = require("config.ui.statusline")

local function get_diagnostics()
	local status = {}
	for type, icon in pairs(Icons.diagnostics) do
		local n = vim.diagnostic.get(0, {
			severity = type,
		})

		if #n > 0 then
			local highlight = Statusline.hl("StatusDiagnostic" .. type, true)
			local ret = ("%s %s %d"):format(highlight, icon, #n)

			table.insert(status, ret)
		end
	end

	return table.concat(status, " ")
end

local function get_lsp_names()
	local names = {}
	local attached = vim.lsp.get_clients({
		bufnr = 0,
	})

	table.sort(attached, function(a, b) return a.name < b.name end)

	for _, c in ipairs(attached) do
		names[#names + 1] = Icons.servers[c.name] or Icons.kind_icons.Lsp
	end

	table.insert(names, 1, Statusline.hl("StatusLsp", true))
	return table.concat(names, " ")
end

local M = {}

function M.lsp_hldefs()
	local bg = Statusline.bg
	local get_hl = Statusline.get_hl

	Statusline.set_hl("StatusLsp", {
		fg = get_hl("NonText"),
		bg = bg,
	})

	for type in pairs(Icons.diagnostics) do
		vim.api.nvim_set_hl(0, "StatusDiagnostic" .. type, {
			fg = get_hl("Diagnostic" .. type),
			bg = bg,
		})
	end
end

--- @param active boolean
function M.status(active)
	if not active then
		return ""
	end

	local lsp_names = get_lsp_names()
	local lsp_status = get_diagnostics()

	return table.concat({
		Statusline.highlight(active),
		lsp_names,
		lsp_status,
	}, "")
end

return M
