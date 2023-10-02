local Util = require("config.util")

local augroup = Util.augroup
local autocmd = vim.api.nvim_create_autocmd
local cmd = vim.cmd
local fn = vim.fn

_G.AUTOSAVE = true

autocmd({
	"BufLeave",
	"FocusLost",
}, {
	callback = function()
		if not _G.AUTOSAVE then
			return
		end

		local bo = vim.bo

		if not bo.readonly and fn.expand("%") ~= "" and bo.buftype == "" then
			cmd.update()
		end
	end,
	desc = "Auto save when leaving the buffer",
	group = augroup("AutoSave"),
})

vim.api.nvim_create_user_command("AutoSaveToggle", function()
	local Logger = require("config.util.logger"):new("Auto Save")
	_G.AUTOSAVE = not _G.AUTOSAVE

	if _G.AUTOSAVE then
		Logger:info("Enabled")
	else
		Logger:info("Disabled")
	end
end, {
	desc = "Toggle auto save",
	nargs = 0,
})

autocmd({
	"FileType",
}, {
	callback = function(event)
		local buffer = event.buf

		vim.bo[buffer].buflisted = false

		Util.nmap("q", cmd.close, {
			buffer = buffer,
			silent = true,
		})
	end,
	desc = "Use [q] to close the buffer for helper files",
	group = augroup("EasyQuit"),
	pattern = vim.tbl_filter(function(ft) return ft ~= "spectre_panel" end, require("config.util.constants").no_format),
})

autocmd({
	"BufEnter",
	"FileType",
}, {
	callback = function()
		local formatoptions_append = {
			"c", -- (default) Auto-wrap comments using 'textwidth', inserting the current comment leader automatically.
			"j", -- (default) Where it makes sense, remove a comment leader when joining lines.
			"l", -- Long lines are not broken in insert mode
			"n", -- When formatting text, recognize numbered lists.
			"q", -- (default) Allow formatting of comments with "gq".
			"r", -- Automatically insert the current comment leader after hitting <Enter> in Insert mode.
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
			"t", -- Auto-wrap text using 'textwidth'
			"v", -- Vi-compatible auto-wrapping in insert mode
			"w", -- Trailing white space indicates a paragraph continues in the next line.
		}

		local opt = vim.opt

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

autocmd({
	"TextYankPost",
}, {
	callback = function()
		vim.highlight.on_yank({
			higroup = "Search",
			timeout = 40,
		})
	end,
	desc = "Highlight yanked text",
	group = augroup("HighlightOnYank"),
	pattern = "*",
})

autocmd({
	"BufWritePre",
}, {
	callback = cmd.TrimAllTrailingWhitespace,
	desc = "Trim whitespace from the end of the line",
	group = augroup("TrimTrailingWhitespace"),
	pattern = "!markdown",
})

autocmd({
	"FocusGained",
}, {
	command = "checktime",
	desc = "Check if we need to reload the file when it changed",
	group = augroup("Checktime"),
})

autocmd({
	"VimResized",
}, {
	callback = function() vim.cmd.tabdo("wincmd =") end,
	desc = "Resize splits if window got resized",
	group = augroup("ResizeSplits"),
})

autocmd({
	"BufWritePre",
}, {
	callback = function(event)
		if event.match:match("^%w%w+://") then
			return
		end

		local file = vim.uv.fs_realpath(event.match) or event.match

		fn.mkdir(fn.fnamemodify(file, ":p:h"), "p")
	end,
	desc = "Auto create dir when saving a file, in case some intermediate directory does not exist",
	group = augroup("AutoCreateDir"),
})
