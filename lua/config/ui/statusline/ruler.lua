local M = {}

--- @param str string
local function get_top_or_bottom(str)
	local percent = tonumber(str) --[[@as number|nil]]

	if not percent then
		return percent
	end

	local Icons = require("config.ui.icons").location

	if percent < 5 then
		return Icons.top
	elseif percent > 95 then
		return Icons.bottom
	end
end

--- @param active boolean
--- @return string rulerformat e.g. `80% 65[12]/120`
--- `<percent>% <line number>[<column number>]/<total lines>`
--- or " " for bottom
function M.get_ruler(active)
	if not active or not require("config.util").is_file() then
		return ""
	end

	local Statusline = require("config.ui.statusline")
	local str = vim.api.nvim_eval_statusline("%p", {}).str --[[@as string]]

	return table.concat({
		Statusline.hl("StatusBlue", true),
		Statusline.pad((get_top_or_bottom(str) or "%p%% %2l[%02c]/%-3L")),
	}, "")
end

return M
