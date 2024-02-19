local Icons = require("ui.icons")
local Util = require("ui.status.line.util")

---@param branch string|nil
---@return string|nil 'branch or jira tag'
---@return string|nil icon
local function get_jira_tag(branch)
	local tag = branch and branch:match("%w%w+-%d+") --[[@as string|nil]]
	local icon = tag and Icons.misc.jira or nil

	return tag, icon
end

local function get_branch()
	local icon = Icons.git.git
	local name = "StatusRed"
	local branch = (vim.b.gitsigns_head or vim.g.gitsigns_head) or nil --[[@as string|nil]]

	if not branch then
		return ""
	end

	local component = {
		Util.hl(name),
		icon,
	}

	if branch == "master" or branch == "main" then
		return table.concat(component, "")
	end

	local jira_tag, jira_icon = get_jira_tag(branch)

	if jira_tag and jira_icon then
		return table.concat({
			Util.hl("StatusBlue"),
			jira_icon,
			jira_tag,
		}, " ")
	end

	table.insert(component, branch)

	return table.concat(component, " ")
end

---@param count number
---@param icon string
---@param highlight string
local function get_status_element(count, icon, highlight)
	if not count or count == 0 then
		return ""
	end

	return ("%s%s %d "):format(Util.hl(highlight), icon, count) or ""
end

---@return string 'git status'
local function get_status()
	local fallback, status = require("ui.status.line.util").gitsigns_ok("")

	if not status then
		return fallback or ""
	end

	if status.added == 0 and status.changed == 0 and status.removed == 0 then
		return ""
	end
	local elements = {}

	for _, value in pairs({
		{ status.added, Icons.git.added, "StatusGreen" },
		{ status.changed, Icons.git.modified, "StatusMagenta" },
		{ status.removed, Icons.git.removed, "StatusRed" },
	}) do
		table.insert(elements, get_status_element(value[1], value[2], value[3]))
	end
	return table.concat(elements, "")
end

local M = {}

---@param active boolean
---@return string 'git branch and status component' e.g. `󰊢  +2 ~4 -1`
function M.status(active)
	if not active or not require("util").is_file() then
		return ""
	end

	return table.concat({
		get_branch(),
		get_status(),
	}, " ")
end

return M
