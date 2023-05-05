local logger = require("config.util.logger")
local util = require("config.util")

local session_string = "sessions"
local session_file_name = "Session.vim"
local api = vim.api
local fn = vim.fn
local cmd = vim.cmd

local SessionGroup = api.nvim_create_augroup(session_string, { clear = true })
local M = {}

local is_file_readable = fn.filereadable(session_file_name) == 1 and 1

local function create_session()
	cmd.mksession({ mods = { emsg_silent = true } })
	if is_file_readable then
		logger.info({ msg = "New session started", title = session_string })
	end
end

function M.load_session()
	if is_file_readable then
		cmd.source({ args = { session_file_name }, mods = { silent = false, emsg_silent = true } })

		logger.info({ msg = "Loaded session!", title = session_string })
	else
		create_session()
	end
end

api.nvim_create_autocmd("VimEnter", {
	group = SessionGroup,
	nested = true,
	callback = function()
		local path = fn.expand("%")

		if fn.argc() > 0 or string.match(path, "man://*") or not util.is_vim() then
			return
		end

		if is_file_readable then
			logger.info({ msg = "Session file found", title = session_string })
		else
			create_session()
		end
	end,
})

api.nvim_create_autocmd("VimLeavePre", {
	group = SessionGroup,
	callback = function()
		if not is_file_readable or fn.argc() > 0 or not util.is_vim() then
			return
		end

		cmd.argdelete({ range = { 0, fn.argc() } })
		cmd.mksession({ bang = true })
	end,
})

return M
