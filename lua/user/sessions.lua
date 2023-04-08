local session_string = "sessions"
local session_file_name = "Session.vim"
local logger = require("utils.logger")
local utils = require("utils")
local api = vim.api
local fn = vim.fn
local cmd = vim.cmd

local SessionGroup = api.nvim_create_augroup(session_string, { clear = true })

api.nvim_create_autocmd("VimEnter", {
	group = SessionGroup,
	nested = true,
	callback = function()
		local path = fn.expand("%")

		if fn.argc() > 0 or string.match(path, "man://*") or not utils.is_vim() then
			return
		end

		if fn.filereadable(session_file_name) == 1 then
			cmd.source({ args = { session_file_name }, mods = { silent = false, emsg_silent = true } })

			vim.defer_fn(function() logger.info({ msg = "Loaded session!", title = session_string }) end, 500)
		else
			cmd.mksession({ mods = { emsg_silent = true } })
			if fn.filereadable(session_file_name) == 1 then
				vim.defer_fn(function() logger.info({ msg = "Loaded session!", title = session_string }) end, 500)
			end
		end
	end,
})

api.nvim_create_autocmd("VimLeavePre", {
	group = SessionGroup,
	callback = function()
		if fn.filereadable(session_file_name) == 0 or fn.argc() > 0 or not utils.is_vim() then
			return
		end

		cmd.argdelete({ range = { 0, fn.argc() } })
		cmd.mksession({ bang = true })
	end,
})
