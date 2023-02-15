local utils = require("utils")
local no_format = require("utils.no_format")

local EasyQuitGroup = utils.augroup("EasyQuit", {})
utils.autocmd({ "FileType" }, {
	group = EasyQuitGroup,
	pattern = no_format,
	callback = function()
		vim.cmd([[
             nnoremap <silent> <buffer> q :close<CR>
             set nobuflisted
    ]])
	end,
	desc = "Use [q] to close the buffer for helper files",
})

local AutoSaveGroup = utils.augroup("AutoSave", {})
utils.autocmd({ "BufLeave", "FocusLost" }, {
	group = AutoSaveGroup,
	callback = function()
		if not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
			vim.cmd.update()
		end
	end,
	desc = "Auto save when leaving the buffer",
})

local HighlightYankGroup = utils.augroup("HighlightYank", {})
utils.autocmd("TextYankPost", {
	group = HighlightYankGroup,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({
			higroup = "IncSearch",
			timeout = 40,
		})
	end,
	desc = "Highlight yanked text",
})

local StripWhitespaceGroup = utils.augroup("StripWhitespace", {})
utils.autocmd({ "BufWritePre" }, {
	group = StripWhitespaceGroup,
	pattern = "!markdown",
	command = [[%s/\s\+$//e]],
	desc = "Strip whitespace from the end of the line",
})

local ToggleWindowOptionsGroup = utils.augroup("ToggleWindowOptions", {})
utils.autocmd("WinLeave", {
	group = ToggleWindowOptionsGroup,
	pattern = "*",
	desc = "Toggle cursorline and relative number off",
	callback = function()
		vim.opt.cursorline = false
		vim.opt.relativenumber = false
	end,
})

utils.autocmd({ "WinEnter" }, {
	group = ToggleWindowOptionsGroup,
	desc = "Toggle cursorline and relative number on",
	callback = function()
		if not vim.tbl_contains(no_format, vim.bo.filetype) then
			vim.opt.cursorline = true
			vim.opt.relativenumber = true
		else
			vim.opt.colorcolumn = ""
		end
	end,
})
