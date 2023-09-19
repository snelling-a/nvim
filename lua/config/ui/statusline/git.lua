local Icons = require("config.ui.icons")
local Statusline = require("config.ui.statusline")

--- @param branch string
--- @return string|nil 'branch or jira tag'
--- @return string|nil icon
local function get_jira_tag(branch)
	local tag = branch:match("%w%w+-%d+") --[[@as string|nil]]
	local icon = tag and Icons.misc.jira or nil

	return tag, icon
end

local function get_branch()
	local branch = (vim.b.gitsigns_head or vim.g.gitsigns_head) or nil --[[@as string|nil]]

	if branch == "master" or branch == "main" then
		branch = nil
	end

	local jira_tag, jira_icon

	if branch then
		jira_tag, jira_icon = get_jira_tag(branch)
	end

	branch = jira_tag or branch or ""

    return table.concat({
			Statusline.hl((jira_icon and "StatusBlue" or "StatusRed"), true),
			(" %s %s "):format(jira_icon or Icons.git.git, branch),
		},'')
end

local function get_status_element(count, icon)
	if not count or count == 0 then
		return ""
	end
	return (count > 0 and ("%s %d "):format(icon, count)) or ""
end

--- @return string 'git status'
local function get_status()
	local fallback, status = require("config.ui.statusline.utils").gitsigns_ok("")

	if not status then
		return fallback or ""
	end

	if status.added == 0 and status.changed == 0 and status.removed == 0 then
		return ""
	end

	local highlight = Statusline.hl

	return table.concat({
		highlight("StatusGreen", true),
		get_status_element(status.added, Icons.git.added),
		highlight("StatusMagenta", true),
		get_status_element(status.changed, Icons.git.modified),
		highlight("StatusRed", true),
		get_status_element(status.removed, Icons.git.removed),
	}, "")
end

local M = {}

--- @param active boolean
--- @return string 'git branch and status component' e.g. `󰊢  +2 ~4 -1`
function M.status(active)
	if not active or not require("config.util").is_file() then
		return ""
	end

	return table.concat({
		get_branch(),
		get_status(),
	}, "")
end

return M
