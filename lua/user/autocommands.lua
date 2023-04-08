local no_format = require("utils.no_format")

local api = vim.api
local augroup = api.nvim_create_augroup
local autocmd = api.nvim_create_autocmd
local bo = vim.bo
local cmd = vim.cmd
local fn = vim.fn
local opt = vim.opt

local AutoSaveGroup = augroup("AutoSave", {})
autocmd({ "BufLeave", "FocusLost" }, {
	callback = function()
		if not bo.readonly and fn.expand("%") ~= "" and bo.buftype == "" then
			cmd.update()
		end
	end,
	desc = "Auto save when leaving the buffer",
	group = AutoSaveGroup,
})

local EasyQuitGroup = augroup("EasyQuit", {})
autocmd({ "FileType" }, {
	callback = function()
		if bo.ft == "toggleterm" then
			return
		end

		api.nvim_buf_set_keymap(0, "n", "q", "", {
			callback = function() api.nvim_buf_delete(0, { force = true }) end,
		})
	end,
	desc = "Use [q] to close the buffer for helper files",
	group = EasyQuitGroup,
	pattern = no_format,
})

local FormatOptionsGroup = augroup("FormatOptions", {})
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
	group = FormatOptionsGroup,
	pattern = "*",
})

local HighlightYankGroup = augroup("HighlightYank", {})
autocmd("TextYankPost", {
	callback = function() vim.highlight.on_yank({ higroup = "IncSearch", timeout = 40 }) end,
	desc = "Highlight yanked text",
	group = HighlightYankGroup,
	pattern = "*",
})

local StripWhitespaceGroup = augroup("StripWhitespace", {})
autocmd({ "BufWritePre" }, {
	callback = function() cmd.substitute([[/\s\+$/]], [[\=submatch(0)]], [[e]]) end,
	desc = "Strip whitespace from the end of the line",
	group = StripWhitespaceGroup,
	pattern = "!markdown",
})

local ToggleWindowOptionsGroup = augroup("ToggleWindowOptions", {})
autocmd("WinLeave", {
	callback = function()
		opt.cursorline = false
		opt.relativenumber = false
	end,
	desc = "Toggle cursorline and relative number off",
	group = ToggleWindowOptionsGroup,
	pattern = "*",
})

autocmd("WinEnter", {
	callback = function()
		if not vim.tbl_contains(no_format, bo.filetype) then
			opt.cursorline = true
			opt.relativenumber = true
		else
			opt.colorcolumn = ""
		end
	end,
	desc = "Toggle cursorline and relative number on",
	group = ToggleWindowOptionsGroup,
})
