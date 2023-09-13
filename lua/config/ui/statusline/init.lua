local api = vim.api

local M = {}

--- @param name string
--- @return table<string,any>
function M.get_hl(name)
	return api.nvim_get_hl(0, {
		name = name,
	})
end

---@param name string
---@param val vim.api.keyset.highlight
function M.set_hl(name, val) return api.nvim_set_hl(0, name, val) end

M.bg = M.get_hl("StatusLine").bg

function M.hl(name, active)
	if active == 0 then
		return ""
	end

	return "%#" .. name .. "#"
end

function M.highlight(num, active)
	if active == 1 then
		if num == 1 then
			return "%#User2#"
		end
		if num == 2 then
			return "%#User4#"
		end
		return "%#StatusLine#"
	end
	return "%#StatusLineNC#"
end

function M.recording()
	local recording = vim.fn.reg_recording()

	if recording ~= "" then
		return "%#ModeMsg#  @[" .. recording .. "] "
	else
		return ""
	end
end

function M.pad(x) return "%( " .. x .. " %)" end

---@param sections string[][]
---@return string stausline
function M.parse_sections(sections)
	local result = {} ---@type string[]

	for _, s in ipairs(sections) do
		local sub_result = {} ---@type string[]

		for _, part in ipairs(s) do
			sub_result[#sub_result + 1] = part
		end

		result[#result + 1] = table.concat(sub_result)
	end

	-- Leading '%=' reeded for first Statusline.highlight to work
	return "%=" .. table.concat(result, "%=")
end

return M
