local Util = require("config.util")
if not Util.is_vim() then
	return {}
end

local keep = {
	"buffers", -- hidden and unloaded buffers, not just those in windows
	"curdir", -- the current directory
	"globals", -- global variables that start with an uppercase letter and contain at least one lowercase letter.
	"skiprtp", -- exclude 'runtimepath' and 'packpath' from the options
	"resize", -- size of the Vim window: 'lines' and 'columns'
	"tabpages", -- all tab pages
}
local lose = {
	"folds", -- manually created folds, opened/closed folds and local fold options
	"help", -- 	the help window
	"blank", -- empty windows
	"localoptions", -- options and mappings local to a window or buffer (not global values for local options)
	"options", -- all options and mappings (also global values for local options)
	"terminal", -- include terminal windows where the command can be restored
	"sesdir", -- the directory in which the session file is located will become the current directory
	"winpos", -- position of the whole Vim window
	"winsize", -- window sizes
}

for _, v in pairs(keep) do
	vim.opt.sessionoptions:append(v)
end
for _, v in pairs(lose) do
	vim.opt.sessionoptions:remove(v)
end

vim.opt.sessionoptions = { "globals", "skiprtp" }
-- vim.opt.sessionoptions = {
-- 	"buffers",
-- 	"curdir",
-- 	"tabpages",
-- 	"winsize",
-- }
vim.opt.sessionoptions:remove({ "blank", "help", "skiprtp", "terminal" })
vim.opt.sessionoptions:append({ "skiprtp" })

local session_string = "Sessions"

local Logger = require("config.util.logger"):new(session_string)

local sessions_dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/")

vim.fn.mkdir(sessions_dir, "p", 0700)

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
