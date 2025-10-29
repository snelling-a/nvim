local Icons = require("icons")
local ok, icons = pcall(require, "mini.icons")

local M = {}

M.file_icon = Icons.misc.document
M.folder_icon = "%#Directory#" .. Icons.misc.folder_closed .. "%#Winbar#"

---@type string[]
M.kinds = {}
for k, v in pairs(vim.lsp.protocol.SymbolKind) do
	if type(k) == "string" then
		M.kinds[v] = k
	end
end

---@type string[]
M.symbol_kind_icon = {}
if ok then
	for i, name in pairs(M.kinds) do
		---@type string, string
		local icon, hl = icons.get("lsp", name)
		M.symbol_kind_icon[i] = ("%s%s%%#Winbar# "):format(hl and "%#" .. hl .. "#" or "", icon or Icons.misc.unknown)
	end
end

M.get_component_icon = function(component)
	if ok then
		---@type string, string
		local icon, hl = icons.get("extension", component)
		return "%#" .. hl .. "#" .. (icon or M.file_icon) .. "%#Winbar# " .. component
	else
		return M.file_icon .. " " .. component
	end
end

---@param symbol lsp.DocumentSymbol
---@return string
function M.get_kind(symbol)
	return M.symbol_kind_icon[symbol.kind]
		or ("%s%s%%#Winbar# "):format("", vim.lsp.protocol.SymbolKind[symbol.kind] or "")
end

return M
