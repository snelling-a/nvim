local M = {}

--- wrapper around |nvim_create_augroup|
---@param name string The name of the group
---@param clear? boolean defaults to true. Clear existing commands if the group already exists `autocmd-groups`.
---@return integer Id id of the created group.
function M.augroup(name, clear)
	return vim.api.nvim_create_augroup("user." .. name, { clear = clear ~= false })
end

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	callback = function(event)
		local bufnr = event.buf
		if vim.bo[bufnr].filetype == "gitcommit" or vim.b[bufnr].last_loc then
			return
		end

		vim.b[bufnr].last_loc = true

		local mark = vim.api.nvim_buf_get_mark(bufnr, '"')
		local line_count = vim.api.nvim_buf_line_count(bufnr)

		if mark[1] > 0 and mark[1] <= line_count then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
	desc = "Go to last loc when opening a buffer",
	group = M.augroup("buf.last_loc"),
})

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	callback = function(event)
		if event.match:match("^%w%w+:[\\/][\\/]") then
			return
		end

		local file = vim.uv.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
	desc = "Auto create dir when saving a file, in case some intermediate directory does not exist",
	group = M.augroup("create_dir"),
})

function M.sort_spellfile()
	local spellfile = vim.o.spellfile

	vim.cmd.edit({ args = { spellfile } })
	vim.cmd.sort({ args = { "ui" } })
	vim.cmd.mkspell({ args = { spellfile }, bang = true, mods = { emsg_silent = true } })
	vim.cmd.write({ args = { spellfile } })

	if not vim.api.nvim_list_uis()[1] then
		vim.cmd.bdelete()
	end
end

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = M.sort_spellfile,
	group = M.augroup("spell"),
	pattern = "*/spell/*.add",
})

local ui_group = M.augroup("ui")
local function is_disabled_filetype(bufnr)
	return vim.tbl_contains(vim.g.disabled_filetypes, vim.bo[bufnr].filetype)
		or vim.tbl_contains(vim.g.disabled_filetypes, vim.bo[bufnr].buftype)
		or vim.bo[bufnr].filetype == ""
end

vim.api.nvim_create_autocmd({ "CmdlineEnter", "FocusLost", "InsertEnter", "WinLeave" }, {
	callback = function(event)
		if is_disabled_filetype(event.buf) then
			return
		end
		vim.api.nvim_set_option_value("relativenumber", false, { scope = "local", win = 0 })
		vim.api.nvim_set_option_value("cursorline", false, { scope = "local", win = 0 })
	end,
	desc = "Disable UI elements for unfocused windows",
	group = ui_group,
})

vim.api.nvim_create_autocmd({ "BufEnter", "CmdlineLeave", "FocusGained", "InsertLeave", "WinEnter" }, {
	callback = function(event)
		local value = true
		if is_disabled_filetype(event.buf) then
			value = false
			vim.api.nvim_set_option_value("number", value, { scope = "local", win = 0 })
		end

		vim.api.nvim_set_option_value("relativenumber", value, { scope = "local", win = 0 })
		vim.api.nvim_set_option_value("cursorline", value, { scope = "local", win = 0 })
	end,
	desc = "Enable UI elements for focused windows",
	group = ui_group,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	callback = function(event)
		return require("user.keymap.util").quit(event.buf)
	end,
	desc = "Close some filetypes with <q>",
	group = M.augroup("file.quit"),
	pattern = vim.g.disabled_filetypes,
})

vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	callback = function()
		if vim.o.buftype ~= "nofile" then
			vim.cmd.checktime()
		end
	end,
	desc = "Check if we need to reload the file when it changed",
	group = M.augroup("buf.checktime"),
})

vim.api.nvim_create_autocmd({ "TermOpen" }, {
	desc = "Remove UI clutter in the terminal",
	callback = function()
		local is_terminal = vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "terminal"
		vim.o.number = not is_terminal
		vim.o.relativenumber = not is_terminal
		vim.o.signcolumn = is_terminal and "no" or "yes"
	end,
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	callback = function()
		vim.hl.on_yank()
	end,
	desc = "Hightlight on yank/Keep cursor position after yanking",
	group = M.augroup("yank"),
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
	desc = "Resize splits if window got resized",
	group = M.augroup("win.resize"),
})

vim.api.nvim_create_autocmd({ "WinResized" }, {
	pattern = "*",
	callback = function()
		---@type boolean
		---@diagnostic disable-next-line: undefined-field
		local wrap = vim.opt_local.wrap:get()

		if wrap then
			return
		end

		local win_width = vim.api.nvim_win_get_width(0)
		---@type integer
		local text_width = vim.opt.textwidth._value
		local wide_enough = win_width < text_width + 1
		vim.api.nvim_set_option_value("wrap", wide_enough, {})
	end,
})

vim.api.nvim_create_autocmd({ "User" }, {
	callback = function()
		local stats = require("lazy").stats()
		local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
		local lazy_icon = require("icons").misc.lazy
		local msg = ("%s loaded %s / %s plugins in %sms %s"):format(lazy_icon, stats.loaded, stats.count, ms, lazy_icon)

		vim.notify(msg)
	end,
	group = M.augroup("startup"),
	once = true,
	pattern = "LazyVimStarted",
})

vim.api.nvim_create_autocmd({ "BufEnter" }, {
	callback = function()
		vim.opt_local.spelloptions:remove("noplainbuffer")
	end,
	group = M.augroup("spelloptions"),
})
return M
