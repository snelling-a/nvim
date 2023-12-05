local api = vim.api

local M = {}

---@param fallback string
---@return string|nil
---@return nil|Gitsigns.StatusObj
function M.gitsigns_ok(fallback)
	---@type boolean, Gitsigns.StatusObj
	local ok, gitsigns = pcall(function()
		return (assert(vim.b.gitsigns_status_dict ~= nil)) and vim.b.gitsigns_status_dict or {}
	end)

	if not ok then
		return fallback, nil
	else
		return nil, gitsigns
	end
end

function M.highlight()
	return "%#StatusLine#"
end

--- Use a statusline highlight group
---@param name string statusline highlight group
---@param active boolean
function M.hl(name, active)
	if not active then
		return ""
	end

	return ("%%#%s#"):format(name)
end

M.no_statusline = ("%s "):format(M.highlight())

---@param str string
function M.pad(str)
	return ("%%(%s %%)"):format(str)
end

---@param sections string[][]
---@return string statusline
function M.parse_sections(sections)
	local result = {} ---@type string[]

	for _, s in ipairs(sections) do
		local sub_result = {} ---@type string[]

		for _, part in ipairs(s) do
			sub_result[#sub_result + 1] = part
		end

		result[#result + 1] = table.concat(sub_result)
	end

	-- Leading '%=' needed for first M.highlight to work
	return ("%%=%s"):format(table.concat(result, "%="))
end

---@param active boolean
function M.recording(active)
	if not active then
		return ""
	end

	local reg_recording = vim.fn.reg_recording()

	if reg_recording ~= "" then
		return ("%%#MoreMsg# @[%s] "):format(reg_recording)
	else
		return ""
	end
end

---@param name string
---@param val vim.api.keyset.highlight
function M.set_hl(name, val)
	val = require("util").tbl_extend_force(val, { bg = (vim.api.nvim_get_hl(0, { name = "StatusLine" })).bg })
	return api.nvim_set_hl(0, name, val)
end

M.bg = require("ui").get_hl("StatusLine", "bg")

return M
