local Icons = require("icons")
local cache = require("user.statusline.cache")

---@class user.statusline
---@field cache user.statusline.cache
---@field components user.statusline.components
local M = setmetatable({}, {
	__index = function(_, k)
		return require("user.statusline." .. k)
	end,
})

---@param name string
---@param active 1|0
---@return string
function M.hl(name, active)
	if active == 0 then
		return ""
	end
	return "%#" .. name .. "#"
end
---@param num 1|2
---@param active 1|0
---@return string
function M.highlight(num, active)
	if active == 1 then
		return num == 1 and "%#PmenuSel#" or "%#StatusLine#"
	end
	return "%#StatusLineNC#"
end

function M.hldefs()
	M.hl_cache = {}
	local bg = cache.get_hl("StatusLine").bg

	for k in pairs(Icons.diagnostics) do
		local fg = cache.get_hl("Diagnostic" .. k).fg
		vim.api.nvim_set_hl(0, "Diagnostic" .. k .. "Status", { fg = fg, bg = bg })
	end

	vim.api.nvim_set_hl(0, "StatusLineTreesitter", { fg = cache.get_hl("MoreMsg").fg, bg = bg })
	vim.api.nvim_set_hl(0, "StatuslineVCS", { fg = bg, bg = cache.get_hl("DiffChange").fg, bold = true })
	vim.api.nvim_set_hl(0, "StatuslineRuler", { fg = bg, bg = cache.get_hl("Special").fg, bold = true })
end

---@param sections string[][]
---@return string
function M.parse_sections(sections)
	---@type string[]
	local result = {}
	for _, section in ipairs(sections) do
		---@type string[]
		local sub = {}
		for _, part in ipairs(section) do
			sub[#sub + 1] = part
		end
		result[#result + 1] = table.concat(sub)
	end
	return table.concat(result, "%=")
end

return M
