--- @param branch string
--- @return string 'branch or jira tag'
local function get_jira_tag(branch) return branch:match("%w%w+-%d+") or branch end

--- @return string branch
local function get_branch()
	local branch = (vim.b.gitsigns_head or vim.g.gitsigns_head) or "" --[[@as string]]

	if branch == "master" or branch == "main" then
		return require("config.ui.icons").git.git
	end

	return branch
end

--- @return string 'git status'
local function get_status() return vim.b.gitsigns_status or "" end

local M = {}

function M.status()
	if not require("config.util").is_file() then
		return ""
	end

	local branch = get_branch()
	local jira_tag = get_jira_tag(branch)
	local status = get_status()

	return (jira_tag or branch) .. " " .. status
end

return M
