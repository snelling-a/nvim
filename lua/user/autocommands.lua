local utils = require("utils")

local EasyQuitGroup = utils.augroup("EasyQuit", {})
utils.autocmd({ "FileType" }, {
	group = EasyQuitGroup,
	pattern = {
		"fugitive",
		"git",
		"help",
		"lspinfo",
		"qf",
	},
	callback = function()
		vim.cmd([[
             nnoremap <silent> <buffer> q :close<CR>
             set nobuflisted
    ]])
	end,
})

local AutoSaveGroup = utils.augroup("AutoSave", {})
utils.autocmd({ "BufLeave", "FocusLost" }, {
	group = AutoSaveGroup,
	callback = function()
		if not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
			vim.cmd.update()
		end
	end,
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
})

local StripWhitespaceGroup = utils.augroup("StripWhitespace", {})
utils.autocmd({ "BufWritePre" }, {
	group = StripWhitespaceGroup,
	pattern = "*",
	command = [[%s/\s\+$//e]],
})
