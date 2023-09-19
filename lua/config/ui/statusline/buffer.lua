local Icons = require("config.ui.icons")

local pad = require("config.ui.statusline").pad

local function get_buf_names()
	local statusline_name = vim.api.nvim_eval_statusline("%f", {}).str --[[@as string]]
	local buf_name = vim.api.nvim_buf_get_name(0)

	return buf_name, statusline_name
end

local M = {}

local function get_special_buf_type()
	local buf_name, statusline_name = get_buf_names()

	if vim.startswith(buf_name, "fugitive://") then
		statusline_name = pad(Icons.git.compare) .. pad(vim.api.nvim_eval_statusline("%{FugitiveStatusline()}", {}).str)
	elseif vim.startswith(buf_name, "issue://") then
		statusline_name = pad(Icons.git.github)
	elseif vim.startswith(buf_name, "thread://") then
		statusline_name = pad(Icons.misc.thread)
	elseif vim.startswith(statusline_name, "PullRequest:") then
		statusline_name = pad(Icons.git.pull)
	elseif vim.startswith(statusline_name, "undotree") then
		statusline_name = pad(Icons.misc.undo)
	elseif vim.startswith(statusline_name, "diffpanel") then
		statusline_name = pad(Icons.git.diff)
	elseif statusline_name == "OUTLINE" then
		statusline_name = pad(Icons.misc.outline)
	elseif not require("config.util").is_file() then
		statusline_name = ""
	end

	return statusline_name
end

--- @param git_status_root string
local function get_git_path(git_status_root)
	local buf_name = get_buf_names()

	local project_root = vim.fn.fnamemodify(git_status_root, ":t"):gsub("%-", "%%-") --[[@as string]]
	local needle = ("^%%S*(%s)"):format(project_root)

	return (buf_name:gsub(needle, "%1"))
end

--- @return string file name
--- relative to git root if available or symbol based on plugin/function
function M.name()
	if vim.bo.buftype ~= "" then
		return get_special_buf_type()
	end

	local _, statusline_name = get_buf_names()

	local fallback, status = require("config.ui.statusline.utils").gitsigns_ok(statusline_name)

	if status and status.root then
		return get_git_path(status.root)
	end

	return fallback --[[@as string]]
end

return M
