local api = vim.api

local M = {}

--- @param name string
--- @return table<string,any>
function M.get_hl(name)
	return api.nvim_get_hl(0, {
		name = name,
	})
end

--- @param name string
--- @param val vim.api.keyset.highlight
function M.set_hl(name, val) return api.nvim_set_hl(0, name, val) end

M.bg = M.get_hl("StatusLine").bg
M.fg = M.get_hl("StatusLine").fg

--- Use a statusline highlight group
--- @param name string statusline highlight group
--- @param active boolean
function M.hl(name, active)
	if not active then
		return ""
	end

	return "%#" .. name .. "#"
end

--- @param active boolean
function M.highlight(active) return active and "%#StatusLine#" or "%#StatusLineNC#" end

function M.recording()
	local recording = vim.fn.reg_recording()

	if recording ~= "" then
		return "%#MoreMsg# @[" .. recording .. "] "
	else
		return ""
	end
end

--- @param str string
function M.pad(str) return ("%%(%s %%)"):format(str) end

--- @param sections string[][]
--- @return string stausline
function M.parse_sections(sections)
	local result = {} --- @type string[]

	for _, s in ipairs(sections) do
		local sub_result = {} --- @type string[]

		for _, part in ipairs(s) do
			sub_result[#sub_result + 1] = part
		end

		result[#result + 1] = table.concat(sub_result)
	end

	-- Leading '%=' needed for first Statusline.highlight to work
	return "%=" .. table.concat(result, "%=")
end

return M
