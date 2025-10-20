---@type string|nil
local fd_cmd
if vim.fn.executable("fd") == 1 then
	fd_cmd = "fd --hidden --no-ignore-vcs"
elseif vim.fn.executable("rg") == 1 then
	fd_cmd = "rg --files --hidden"
else
	vim.notify("Neither fd nor rg found! findfunc will be slow.", vim.log.levels.WARN)
	fd_cmd = nil
end

local M = {}

local file_cache = {}

function M.findfunc(cmdarg)
	if not fd_cmd then
		return vim.fn.systemlist("find . -type f")
	end
	if not next(file_cache) then
		file_cache = vim.fn.systemlist(fd_cmd)
	end
	if #cmdarg == 0 then
		return file_cache
	end
	return vim.fn.matchfuzzy(file_cache, cmdarg)
end

return M
