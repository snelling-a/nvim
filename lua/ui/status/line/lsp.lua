local Icons = require("ui.icons")
local Util = require("ui.status.line.util")

local function get_diagnostics()
	local status = {}
	for type, icon in pairs(Icons.diagnostics) do
		local n = vim.diagnostic.get(0, {
			severity = type,
		})

		if #n > 0 then
			local name = ("StatusDiagnostic%s"):format(type)
			local highlight = Util.hl(name)

			local diagnostic = ("%s %s %d"):format(highlight, icon, #n)

			table.insert(status, diagnostic)
		end
	end
	if #status > 0 then
		table.insert(status, 1, " ")
	end

	return table.concat(status, "")
end

local function get_lsp_names()
	local clients = vim.lsp.get_clients({ bufnr = 0 })

	table.sort(clients, function(a, b)
		return a.name < b.name
	end)

	local client_names = {}

	for _, c in ipairs(clients) do
		client_names[#client_names + 1] = Icons.servers[c.name] or Icons.kind_icons.Lsp
	end

	table.insert(client_names, 1, Util.hl("StatusLsp"))

	return table.concat(client_names, " ")
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
	if not active or not require("util").is_file() then
		return ""
	end

	return table.concat({
		Util.highlight(),
		get_lsp_names(),
		get_diagnostics(),
	}, "")
end

return M
