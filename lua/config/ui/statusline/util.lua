local Util = require("config.ui.util")
local api = vim.api

local M = {}

--- @param name string
--- @param what? What
function M.get_hl(name, what) return Util.get_hl(name, what or "fg") end

--- @param fallback string
--- @return string|nil
--- @return nil|Gitsigns.StatusObj
function M.gitsigns_ok(fallback)
	--- @type boolean, Gitsigns.StatusObj
	local ok, gitsigns = pcall(
		function() return (assert(vim.b.gitsigns_status_dict ~= nil)) and vim.b.gitsigns_status_dict or {} end
	)

	if not ok then
		return fallback, nil
	else
		return nil, gitsigns
	end
end

--- @param active boolean
function M.highlight(active) return active and "%#StatusLine#" or "%#StatusLineNC#" end

--- Use a statusline highlight group
--- @param name string statusline highlight group
--- @param active boolean
function M.hl(name, active)
	if not active then
		return ""
	end

	return "%#" .. name .. "#"
end

M.no_statusline = ("%s "):format(M.highlight(false))

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

function M.recording()
	local recording = vim.fn.reg_recording()

	if recording ~= "" then
		return "%#MoreMsg# @[" .. recording .. "] "
	else
		return ""
	end
end

--- @param name string
--- @param val vim.api.keyset.highlight
function M.set_hl(name, val) return api.nvim_set_hl(0, name, val) end

M.bg = Util.get_hl("StatusLine", "bg")

return M