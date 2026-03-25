local M = {}

--- Get command output or nil on failure
---@param cmd string[]
---@return string|nil
local function cmd_output(cmd)
	local result = vim.system(cmd, { text = true }):wait()
	if result.code ~= 0 or not result.stdout then
		return nil
	end
	return vim.trim(result.stdout)
end

--- Get git root directory
---@return string|nil
local function git_root()
	return cmd_output({ "git", "rev-parse", "--show-toplevel" })
end

--- Get commit hash that exists on remote (merge-base with upstream)
---@return string|nil
local function git_rev()
	-- Try to get the merge-base with upstream tracking branch
	local rev = cmd_output({ "git", "merge-base", "HEAD", "@{u}" })
	if rev then
		return rev
	end
	-- Fallback to HEAD if no upstream
	return cmd_output({ "git", "rev-parse", "HEAD" })
end

--- Get remote URL and convert to HTTPS browse URL
---@return string|nil
local function remote_url()
	local url = cmd_output({ "git", "remote", "get-url", "origin" })
	if not url then
		return nil
	end

	-- Convert SSH to HTTPS: git@github.com:user/repo.git -> https://github.com/user/repo
	url = url:gsub("^git@([^:]+):", "https://%1/")
	-- Remove .git suffix
	url = url:gsub("%.git$", "")

	return url
end

--- Build permalink URL based on host
---@param base string
---@param rev string
---@param file string
---@param lstart number
---@param lend number
---@return string
local function build_url(base, rev, file, lstart, lend)
	---@type string
	local line_anchor

	-- GitHub, GitLab, Bitbucket all use slightly different formats
	if base:match("github") then
		if lstart == lend then
			line_anchor = string.format("#L%d", lstart)
		else
			line_anchor = string.format("#L%d-L%d", lstart, lend)
		end
		return string.format("%s/blob/%s/%s?plain=1%s", base, rev, file, line_anchor)
	elseif base:match("gitlab") then
		if lstart == lend then
			line_anchor = string.format("#L%d", lstart)
		else
			line_anchor = string.format("#L%d-%d", lstart, lend)
		end
		return string.format("%s/-/blob/%s/%s%s", base, rev, file, line_anchor)
	elseif base:match("bitbucket") then
		if lstart == lend then
			line_anchor = string.format("#lines-%d", lstart)
		else
			line_anchor = string.format("#lines-%d:%d", lstart, lend)
		end
		return string.format("%s/src/%s/%s%s", base, rev, file, line_anchor)
	end

	-- Default to GitHub-style
	if lstart == lend then
		line_anchor = string.format("#L%d", lstart)
	else
		line_anchor = string.format("#L%d-L%d", lstart, lend)
	end
	return string.format("%s/blob/%s/%s?plain=1%s", base, rev, file, line_anchor)
end

--- Generate and copy git permalink to clipboard
function M.link()
	local root = git_root()
	if not root then
		vim.notify("Not in a git repository", vim.log.levels.ERROR)
		return
	end

	local rev = git_rev()
	if not rev then
		vim.notify("Failed to get git revision", vim.log.levels.ERROR)
		return
	end

	local base = remote_url()
	if not base then
		vim.notify("Failed to get remote URL", vim.log.levels.ERROR)
		return
	end

	-- Get file path relative to git root
	local filepath = vim.api.nvim_buf_get_name(0)
	if filepath == "" then
		vim.notify("Buffer has no file", vim.log.levels.ERROR)
		return
	end

	local relpath = filepath:sub(#root + 2) -- +2 for trailing slash

	-- Get line range
	local mode = vim.fn.mode()
	---@type integer, integer
	local lstart, lend

	if mode == "v" or mode == "V" or mode == "\22" then
		-- Visual mode: get selection range
		vim.cmd('normal! "')
		lstart = vim.fn.line("v")
		lend = vim.fn.line(".")
		if lstart > lend then
			---@type integer, integer
			lstart, lend = lend, lstart
		end
	else
		-- Normal mode: current line
		lstart = vim.fn.line(".")
		lend = lstart
	end

	local url = build_url(base, rev, relpath, lstart, lend)

	vim.fn.setreg("+", url)
	vim.notify("Yanked: " .. url)
end

return M
