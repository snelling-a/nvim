local no_format = require("utils.no_format")
local utils = require("utils")

local AutoSaveGroup = utils.augroup("AutoSave", {})
utils.autocmd({ "BufLeave", "FocusLost" }, {
	callback = function()
		if not vim.bo.readonly and vim.fn.expand("%") ~= "" and vim.bo.buftype == "" then
			vim.cmd.update()
		end
	end,
	desc = "Auto save when leaving the buffer",
	group = AutoSaveGroup,
})

local EasyQuitGroup = utils.augroup("EasyQuit", {})
utils.autocmd({ "FileType" }, {
	callback = function()
		if vim.bo.ft == "toggleterm" then
			return
		end

		vim.api.nvim_buf_set_keymap(0, "n", "q", "", {
			callback = function() vim.api.nvim_buf_delete(0, { force = true }) end,
		})
	end,
	desc = "Use [q] to close the buffer for helper files",
	group = EasyQuitGroup,
	pattern = no_format,
})

local FormatOptionsGroup = utils.augroup("FormatOptions", {})
utils.autocmd({ "BufEnter", "FileType" }, {
	callback = function()
		-- luacheck: push no max line length
		utils.opt.formatoptions:append("c") -- (default) Auto-wrap comments using 'textwidth', inserting the current comment leader automatically.
		utils.opt.formatoptions:append("j") -- (default) Where it makes sense, remove a comment leader when joining lines.
		utils.opt.formatoptions:append("l") -- Long lines are not broken in insert mode
		utils.opt.formatoptions:append("n") -- When formatting text, recognize numbered lists.
		utils.opt.formatoptions:append("q") -- (default) Allow formatting of comments with "gq".
		utils.opt.formatoptions:remove("/") -- When 'o' is included: do not insert the comment leader for a // comment after a statement
		utils.opt.formatoptions:remove("2") -- When formatting text, use the indent of the second line of a paragraph for the rest of the paragraph
		utils.opt.formatoptions:remove("B") -- When joining lines, don't insert a space between two multibyte characters.
		utils.opt.formatoptions:remove("M") -- When joining lines, don't insert a space before or after a multibyte character.
		utils.opt.formatoptions:remove("]") -- Respect 'textwidth' rigorously.
		utils.opt.formatoptions:remove("a") -- Automatic formatting of paragraphs.
		utils.opt.formatoptions:remove("b") -- Like 'v', but only auto-wrap if you enter a blank at or before the wrap margin.
		utils.opt.formatoptions:remove("m") -- Also break at a multibyte character above 255.
		utils.opt.formatoptions:remove("o") -- Auto insert the current comment leader after hitting 'o' or 'O' in Normal mode.
		utils.opt.formatoptions:remove("p") -- Don't break lines at single spaces that follow periods.
		utils.opt.formatoptions:remove("r") -- Automatically insert the current comment leader after hitting <Enter> in Insert mode.
		utils.opt.formatoptions:remove("t") -- Auto-wrap text using 'textwidth'
		utils.opt.formatoptions:remove("v") -- Vi-compatible auto-wrapping in insert mode
		utils.opt.formatoptions:remove("w") -- Trailing white space indicates a paragraph continues in the next line.
		-- luacheck: pop
	end,
	desc = "don't auto comment new line",
	group = FormatOptionsGroup,
	pattern = "*",
})

local HighlightYankGroup = utils.augroup("HighlightYank", {})
utils.autocmd("TextYankPost", {
	callback = function() vim.highlight.on_yank({ higroup = "IncSearch", timeout = 40 }) end,
	desc = "Highlight yanked text",
	group = HighlightYankGroup,
	pattern = "*",
})

local StripWhitespaceGroup = utils.augroup("StripWhitespace", {})
utils.autocmd({ "BufWritePre" }, {
	command = [[%s/\s\+$//e]],
	desc = "Strip whitespace from the end of the line",
	group = StripWhitespaceGroup,
	pattern = "!markdown",
})

local ToggleWindowOptionsGroup = utils.augroup("ToggleWindowOptions", {})
utils.autocmd("WinLeave", {
	callback = function()
		utils.opt.cursorline = false
		utils.opt.relativenumber = false
	end,
	desc = "Toggle cursorline and relative number off",
	group = ToggleWindowOptionsGroup,
	pattern = "*",
})

utils.autocmd("WinEnter", {
	callback = function()
		if not vim.tbl_contains(no_format, vim.bo.filetype) then
			utils.opt.cursorline = true
			utils.opt.relativenumber = true
		else
			vim.opt.colorcolumn = ""
		end
	end,
	desc = "Toggle cursorline and relative number on",
	group = ToggleWindowOptionsGroup,
})
