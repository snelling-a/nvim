local M = {}

---@param active boolean
---@return string rulerformat e.g. `80% 65[12]/120`
--- `<percent>% <line number>[<column number>]/<total lines>`
function M.get_ruler(active)
	if not active or not require("util").is_file() then
		return ""
	end

	local Util = require("ui.status.line.util")

	return table.concat({
		Util.hl("StatusBlue"),
		Util.pad("%p%% %2l[%02c]/%-3L"),
	}, "")
end

return M
