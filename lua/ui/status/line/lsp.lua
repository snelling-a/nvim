local Icons = require("ui.icons")
local Util = require("ui.status.line.util")

local function get_diagnostics()
	local status = {}
	for type, icon in pairs(Icons.diagnostics) do
		local n = vim.diagnostic.get(0, {
			severity = type,
		})

		if #n > 0 then
			local highlight = Util.hl(("StatusDiagnostic%s"):format(type), true)
			local diagnostic = ("%s %s %d"):format(highlight, icon, #n)

			table.insert(status, diagnostic)
		end
	end
	if #status > 0 then
		table.insert(status, 1, " ")
	end

	return table.concat(status, " ")
end

local function get_lsp_names()
	local names = {}
	local attached = vim.lsp.get_clients({
		bufnr = 0,
	})

	table.sort(attached, function(a, b)
		return a.name < b.name
	end)

	for _, c in ipairs(attached) do
		names[#names + 1] = Icons.servers[c.name] or Icons.kind_icons.Lsp
	end

	table.insert(names, 1, Util.hl("StatusLsp", true))
	return table.concat(names, " ")
end

local M = {}

function M.lsp_hldefs()
	local bg = Util.bg
	local get_hl = require("ui").get_hl

	Util.set_hl("StatusLsp", {
		fg = get_hl("NonText"),
		bg = bg,
	})

	for type in pairs(Icons.diagnostics) do
		Util.set_hl(("StatusDiagnostic%s"):format(type), {
			fg = get_hl(("Diagnostic%s"):format(type)),
			bg = bg,
		})
	end
end

---@param active boolean
function M.status(active)
	if not active then
		return ""
	end

	return table.concat({
		Util.highlight(),
		get_lsp_names(),
		get_diagnostics(),
	}, "")
end

return M
