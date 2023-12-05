local is_file = require("util").is_file
local Util = require("ui.status.line.util")

local function filetype_symbol()
	local ok, devicons = pcall(require, "nvim-web-devicons")
	if not ok then
		return ""
	end

	local ft = vim.bo.filetype
	local icon, iconhl = devicons.get_icon_color_by_filetype(ft, { default = true })

	local hlname = ("%s%s"):format("Status", ft)

	Util.set_hl(hlname, {
		fg = iconhl,
		bg = Util.bg,
	})

	return ("%s%s"):format(Util.hl(hlname, true), icon)
end

local M = {}

function M.encoding()
	if not is_file() then
		return ""
	end

	local encoding = vim.bo.fileencoding and vim.bo.fileencoding or vim.o.encoding

	return encoding ~= "utf-8" and encoding or ""
end

---@param active boolean
function M.type(active)
	if not active or not is_file() then
		return ""
	end

	return Util.pad(filetype_symbol())
end

return M
