local session_string = "sessions"
local session_file_name = "Session.vim"
local logger = require("utils.logger")
local utils = require("utils")

local SessionGroup = vim.api.nvim_create_augroup(session_string, { clear = true })

utils.autocmd("VimEnter", {
	group = SessionGroup,
	nested = true,
	callback = function()
		local path = vim.fn.expand("%")

		if vim.fn.argc() > 0 or string.match(path, "man://*") or not utils.is_vim() then
			return
		end

		if vim.fn.filereadable(session_file_name) == 1 then
			vim.cmd.source({ args = { session_file_name }, mods = { silent = false, emsg_silent = true } })

			-- vim.defer_fn(function() logger.info({ msg = "Loaded session!", title = session_string }) end, 500)
		else
			vim.cmd.mksession({ mods = { emsg_silent = true } })
			if vim.fn.filereadable(session_file_name) == 1 then
				vim.defer_fn(function() logger.info({ msg = "Loaded session!", title = session_string }) end, 500)
			end
		end

		if #vim.api.nvim_list_bufs() == 1 and vim.api.nvim_buf_get_name(0) == "" then
			vim.cmd.NvimTreeOpen()
		end
	end,
})

utils.autocmd("VimLeavePre", {
	group = SessionGroup,
	callback = function()
		if vim.fn.filereadable(session_file_name) == 0 or vim.fn.argc() > 0 or not utils.is_vim() then
			return
		end

		local save = "y"

		repeat
			vim.ui.input({ prompt = "Save session? [y/N] ", default = save }, function(input)
				if input then
					save = input
				else
					save = "n"
				end
			end)
		until save:match("^[YyNn]$")

		if save:match("^[Yy]$") then
			vim.cmd.argdelete({ range = { 0, vim.fn.argc() } })
			vim.cmd.mksession({ bang = true })
		end
	end,
})
