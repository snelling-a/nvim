local Util = require("config.util")
if not Util.is_vim() then
	return {}
end

local session_string = "Sessions"

local Logger = require("config.util.logger"):new(session_string)

local sessions_dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/")

vim.fn.mkdir(sessions_dir, "p")

local function get_current_session()
	local separator = require("config.util.path").get_separator()

	local name = vim.fn.getcwd():gsub(separator, "%%")

	return sessions_dir .. name .. ".vim"
end

local function list_sessions() return vim.fn.glob(sessions_dir .. "*.vim", true, true) end

local function get_last_session()
	local sessions = list_sessions()
	table.sort(sessions, function(a, b) return vim.uv.fs_stat(a).mtime.sec > vim.uv.fs_stat(b).mtime.sec end)

	return sessions[1]
end

local fnameescape = vim.fn.fnameescape

local function session_save()
	if Util.are_buffers_listed() then
		vim.cmd.mksession({ args = { fnameescape(get_current_session()) }, bang = true })
	end
end

local function session_load()
	local sfile = get_current_session()

	if sfile and vim.fn.filereadable(sfile) ~= 0 then
		vim.cmd.source({
			args = {
				fnameescape(sfile),
			},
			mods = {
				silent = false,
				emsg_silent = true,
			},
		})

		Logger:info("Session loaded")
	end
end

local group = require("config.util").augroup(session_string, true)
vim.api.nvim_create_autocmd({
	"VimLeavePre",
}, {
	group = group,
	callback = session_save,
})

vim.api.nvim_create_autocmd({
	"UIEnter",
}, {
	group = group,
	callback = function()
		local path = vim.fn.expand("%") --[[@as string]]

		if vim.fn.argc() > 0 or string.match(path, "man://*") or not Util.is_vim() then
			return
		end

		if get_last_session() then
			Logger:info("Session file found")
		end
	end,
})

vim.api.nvim_create_user_command("SessionLoad", session_load, {
	desc = "Load a session",
})

return {}
