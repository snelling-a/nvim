local util = require("config.util")

local api = vim.api
local augroup = util.augroup
local autocmd = api.nvim_create_autocmd
local bo = vim.bo
local cmd = vim.cmd
local fn = vim.fn
local opt = vim.opt
local opt_local = vim.opt_local

autocmd({ "BufLeave", "FocusLost" }, {
	callback = function()
		if not bo.readonly and fn.expand("%") ~= "" and bo.buftype == "" then
			cmd.update()
		end
	end,
	desc = "Auto save when leaving the buffer",
	group = augroup("AutoSave"),
})

autocmd({ "FileType" }, {
	callback = function()
		local filetype = bo.filetype
		if filetype == "toggleterm" or util.should_have_formatting(filetype) then
			return
		end
		api.nvim_buf_set_keymap(0, "n", "q", "", { callback = function() api.nvim_buf_delete(0, { force = true }) end })
	end,
	desc = "Use [q] to close the buffer for helper files",
	group = augroup("EasyQuit"),
})

autocmd({ "BufEnter", "FileType" }, {
	callback = function()
		local formatoptions_append = {
			"c", -- (default) Auto-wrap comments using 'textwidth', inserting the current comment leader automatically.
			"j", -- (default) Where it makes sense, remove a comment leader when joining lines.
			"l", -- Long lines are not broken in insert mode
			"n", -- When formatting text, recognize numbered lists.
			"q", -- (default) Allow formatting of comments with "gq".
		}
		local formatoptions_remove = {
			"/", -- When 'o' is included: do not insert the comment leader for a // comment after a statement
			"2", -- When formatting text, use the indent of the second line of a paragraph for the rest of the paragraph
			"B", -- When joining lines, don't insert a space between two multibyte characters.
			"M", -- When joining lines, don't insert a space before or after a multibyte character.
			"]", -- Respect 'textwidth' rigorously.
			"a", -- Automatic formatting of paragraphs.
			"b", -- Like 'v', but only auto-wrap if you enter a blank at or before the wrap margin.
			"m", -- Also break at a multibyte character above 255.
			"o", -- Auto insert the current comment leader after hitting 'o' or 'O' in Normal mode.
			"p", -- Don't break lines at single spaces that follow periods.
			"r", -- Automatically insert the current comment leader after hitting <Enter> in Insert mode.
			"t", -- Auto-wrap text using 'textwidth'
			"v", -- Vi-compatible auto-wrapping in insert mode
			"w", -- Trailing white space indicates a paragraph continues in the next line.
		}

		for _, v in ipairs(formatoptions_append) do
			opt.formatoptions:append(v)
		end

		for _, v in ipairs(formatoptions_remove) do
			opt.formatoptions:remove(v)
		end
	end,
	desc = "don't auto comment new line",
	group = augroup("FormatOptions"),
	pattern = "*",
})

autocmd("TextYankPost", {
	callback = function() vim.highlight.on_yank({ higroup = "IncSearch", timeout = 40 }) end,
	desc = "Highlight yanked text",
	group = augroup("HighlightOnYank"),
	pattern = "*",
})

autocmd({ "BufWritePre" }, {
	callback = function() cmd.substitute([[/\s\+$/]], [[\=submatch(0)]], [[e]]) end,
	desc = "Strip whitespace from the end of the line",
	group = augroup("StripWhitespace"),
	pattern = "!markdown",
})

local ToggleWindowOptionsGroup = augroup("ToggleWindowOptions")
autocmd("BufLeave", {
	callback = function()
		opt_local.cursorline = false
		opt_local.relativenumber = false

		if util.should_have_formatting(bo.filetype) then
			opt_local.number = true
		else
			opt_local.number = false
		end
	end,
	desc = "Toggle cursorline and relative number off",
	group = ToggleWindowOptionsGroup,
	pattern = "*",
})

autocmd("BufEnter", {
	callback = function()
		if util.should_have_formatting(bo.filetype) then
			opt_local.cursorline = true
			opt_local.number = true
			opt_local.relativenumber = true
		else
			opt_local.colorcolumn = ""
		end
	end,
	desc = "Toggle cursorline and relative number on",
	group = ToggleWindowOptionsGroup,
	pattern = "*",
})
