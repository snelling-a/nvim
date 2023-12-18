local Util = require("util")

local autocmd = vim.api.nvim_create_autocmd

local M = {}

--- wrapper around |nvim_create_augroup|
---@param name string augroup name
---@param clear? boolean clear existing augroup default: true
---@return number group augroup id
function M.augroup(name, clear)
	return vim.api.nvim_create_augroup(("User%s"):format(name), { clear = clear or true })
end

---@param fn fun()
function M.on_very_lazy(fn)
	autocmd("User", {
		callback = function()
			fn()
		end,
		group = M.augroup("VeryLazy"),
		pattern = "VeryLazy",
	})
end

autocmd({
	"FocusGained",
	"TermClose",
	"TermLeave",
}, {
	command = "checktime",
	desc = "Check if we need to reload the file when it changed",
	group = M.augroup("Checktime"),
})

autocmd({ "TextYankPost" }, {
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", priority = 250 })
	end,
	desc = "Highlight on yank",
	group = M.augroup("HighlightOnYank"),
})

autocmd({ "VimResized" }, {
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd.tabdo("wincmd =")
		vim.cmd.tabnext(current_tab)
	end,
	desc = "Resize splits if window got resized",
	group = M.augroup("ResizeSplits"),
})

autocmd({ "BufReadPost" }, {
	---@param ev Ev
	callback = function(ev)
		local exclude = { "gitcommit" }
		local bufnr = ev.buf
		if vim.tbl_contains(exclude, vim.bo[bufnr].filetype) or vim.b[bufnr].last_location then
			return
		end
		vim.b[bufnr].last_location = true
		local mark = vim.api.nvim_buf_get_mark(bufnr, '"')
		local line_count = vim.api.nvim_buf_line_count(bufnr)
		if mark[1] > 0 and mark[1] <= line_count then
			Util.try(function()
				vim.api.nvim_win_set_cursor(0, mark)
			end, { msg = ("Can't set mark %s"):format(mark) })
		end
	end,
	desc = "Go to last location when opening a buffer",
	group = M.augroup("LastLoc"),
})

--- wipeout current buffer or quit all
---@param cmd? function pass a different close function, e.g. vim.cmd.cclose or vim.cmd.lclose
---@return function|nil
function M.easy_quit(cmd)
	if cmd then
		return cmd()
	end

	return Util.are_buffers_listed() and vim.cmd.bwipeout() or vim.cmd.quitall()
end

autocmd({ "FileType" }, {
	---@param ev Ev
	callback = function(ev)
		local bufnr = ev.buf
		vim.bo[bufnr].buflisted = false
		require("keymap").nmap("q", M.easy_quit, { desc = "Easy [q]uit", buffer = bufnr, silent = true })
	end,
	desc = "Easy Quit",
	group = M.augroup("EasyQuit"),
	pattern = require("util").constants.no_format,
})

autocmd({ "FileType" }, {
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
	end,
	desc = "Enable wrap and spell in gitcommit and markdown files",
	group = M.augroup("WrapSpell"),
	pattern = { "gitcommit", "markdown" },
})

autocmd({ "BufWritePre" }, {
	---@param ev Ev
	callback = function(ev)
		if ev.match:match("^%w%w+://") then
			return
		end
		local file = vim.loop.fs_realpath(ev.match) or ev.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
	desc = "Auto create dir when saving a file, in case some intermediate directory does not exist",
	group = M.augroup("AutoCreateDir"),
})

autocmd({
	"BufEnter",
	"FileType",
}, {
	callback = function()
		local formatoptions = {
			"c", -- (default) Auto-wrap comments using 'textwidth', inserting the current comment leader automatically.
			"j", -- (default) Where it makes sense, remove a comment leader when joining lines.
			"l", -- Long lines are not broken in insert mode
			"n", -- When formatting text, recognize numbered lists.
			"q", -- (default) Allow formatting of comments with "gq".
			"r", -- Automatically insert the current comment leader after hitting <Enter> in Insert mode.
			-- "/", -- When 'o' is included: do not insert the comment leader for a // comment after a statement
			-- "2", -- When formatting text, use the indent of the second line of a paragraph for the rest of the paragraph
			-- "B", -- When joining lines, don't insert a space between two multibyte characters.
			-- "M", -- When joining lines, don't insert a space before or after a multibyte character.
			-- "]", -- Respect 'textwidth' rigorously.
			-- "a", -- Automatic formatting of paragraphs.
			-- "b", -- Like 'v', but only auto-wrap if you enter a blank at or before the wrap margin.
			-- "m", -- Also break at a multibyte character above 255.
			-- "o", -- Auto insert the current comment leader after hitting 'o' or 'O' in Normal mode.
			-- "p", -- Don't break lines at single spaces that follow periods.
			-- "t", -- Auto-wrap text using 'textwidth'
			-- "v", -- Vi-compatible auto-wrapping in insert mode
			-- "w", -- Trailing white space indicates a paragraph continues in the next line.
		}

		vim.opt.formatoptions = table.concat(formatoptions) --[[@as vim.opt.formatoptions]]
	end,
	desc = "Set format options",
	group = M.augroup("FormatOptions"),
	pattern = "*",
})

autocmd({ "BufWritePost" }, {
	callback = function()
		vim.cmd.sort({ args = { "ui" } })

		vim.cmd.mkspell({
			args = { "%" },
			bang = true,
			mods = { silent = true },
		})
	end,
	group = M.augroup("Spell"),
	pattern = "*/spell/*.add",
})

return M
