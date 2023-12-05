local Util = require("util")
if not Util.is_vim() then
	return {}
end

local keep = {
	"buffers", -- hidden and unloaded buffers, not just those in windows
	"curdir", -- the current directory
	"globals", -- global variables that start with an uppercase letter and contain at least one lowercase letter.
	"resize", -- size of the Vim window: 'lines' and 'columns'
	"tabpages", -- all tab pages
	-- "blank", -- empty windows
	-- "folds", -- manually created folds, opened/closed folds and local fold options
	-- "help", -- 	the help window
	-- "localoptions", -- options and mappings local to a window or buffer (not global values for local options)
	-- "options", -- all options and mappings (also global values for local options)
	-- "sesdir", -- the directory in which the session file is located will become the current directory
	-- "skiprtp", -- exclude 'runtimepath' and 'packpath' from the options
	-- "terminal", -- include terminal windows where the command can be restored
	-- "winpos", -- position of the whole Vim window
	-- "winsize", -- window sizes
}

vim.opt.sessionoptions = table.concat(keep, ",")

local session_string = "Sessions"

local Logger = require("util.logger"):new(session_string)

local sessions_dir = vim.fn.expand(("%s/sessions/"):format(vim.fn.stdpath("state")))

vim.fn.mkdir(sessions_dir, "p")

local function get_current_session()
	local separator = require("util").get_separator()

	local name = vim.fn.getcwd():gsub(separator, "%%")

	return ("%s%s.vim"):format(sessions_dir, name)
end

local function list_sessions()
	return vim.fn.glob(("%s*.vim"):format(sessions_dir), true, true)
end

local function get_last_session()
	local sessions = list_sessions()
	table.sort(sessions, function(a, b)
		return vim.uv.fs_stat(a).mtime.sec > vim.uv.fs_stat(b).mtime.sec
	end)

	return sessions[1]
end

local fnameescape = vim.fn.fnameescape

local function session_save()
	if Util.are_buffers_listed() then
		vim.cmd.mksession({ args = {
			fnameescape(get_current_session()),
		}, bang = true })
	end
end

local function session_load()
	local sfile = get_current_session()

	if sfile and vim.fn.filereadable(sfile) ~= 0 then
		vim.cmd.source({
			args = { fnameescape(sfile) },
			mods = { silent = false, emsg_silent = true },
		})

		Logger:info("Session loaded")
	end
end

local group = require("autocmd").augroup(session_string, true)
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

		if vim.fn.argc(-1) > 0 or string.match(path, "man://*") or not Util.is_vim() then
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
