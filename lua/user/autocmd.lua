---@class user.Autocmd
local M = {}

--- wrapper around |nvim_create_augroup|
---@param name string The name of the group
---@param clear? boolean defaults to true. Clear existing commands if the group already exists `autocmd-groups`.
---@return integer Id id of the created group.
function M.augroup(name, clear)
	return vim.api.nvim_create_augroup("User" .. name, { clear = clear ~= false })
end

---@param event string|string[] event or events to listen to
---@param opts vim.api.keyset.create_autocmd.opts|vim.api.keyset.create_augroup create_autocmd / create_augroup options
---@return integer # Autocommand id
function M.create_autocmd(event, opts)
	if type(opts.group) == "string" then
		opts.group = M.augroup(opts.group --[[@as string]], opts.clear)
	end

	opts.clear = nil

	return vim.api.nvim_create_autocmd(event, opts)
end

M.create_autocmd({ "BufEnter", "FileType" }, {
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

		vim.opt.formatoptions = table.concat(formatoptions)
	end,
	desc = "Set format options",
	group = "FormatOptions",
	pattern = "*",
})

M.create_autocmd({ "BufReadPost" }, {
	callback = function(event)
		local exclude = { "gitcommit" }
		local bufnr = event.buf
		if vim.tbl_contains(exclude, vim.bo[bufnr].filetype) or vim.b[bufnr].last_loc then
			return
		end
		vim.b[bufnr].last_loc = true
		local mark = vim.api.nvim_buf_get_mark(bufnr, '"')
		local lcount = vim.api.nvim_buf_line_count(bufnr)
		if mark[1] > 0 and mark[1] <= lcount then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
	desc = "Go to last loc when opening a buffer",
	group = "LastLoc",
})

M.create_autocmd({ "BufWritePre" }, {
	callback = function(event)
		if event.match:match("^%w%w+:[\\/][\\/]") then
			return
		end
		local file = vim.uv.fs_realpath(event.match) or event.match
		vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
	end,
	desc = "Auto create dir when saving a file, in case some intermediate directory does not exist",
	group = "AutoCreateDir",
})

M.create_autocmd({ "BufWritePost" }, {
	callback = function()
		vim.cmd.sort({ args = { "ui" } })
		vim.cmd.mkspell({ args = { spellfile }, bang = true, mods = { emsg_silent = true } })
	end,
	group = "Spell",
	pattern = "*/spell/*.add",
})

M.create_autocmd({ "FileType" }, {
	callback = function(event)
		Config.util.easy_quit(event.buf)
	end,
	desc = "Close some filetypes with <q>",
	group = "EasyQuit",
	pattern = DisabledFiletypes,
})

M.create_autocmd({ "FileType" }, {
	callback = function(event)
		local path = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(event.buf), ":p:~:.")
		vim.notify(
			("Big file detected %q.\nSome Neovim features have been disabled."):format(path),
			vim.log.levels.WARN
		)
		vim.schedule(function()
			vim.bo[event.buf].syntax = vim.filetype.match({ buf = event.buf }) or ""
		end)
	end,
	group = "Bigfile",
	pattern = "bigfile",
})

M.create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	callback = function()
		if vim.o.buftype ~= "nofile" then
			vim.cmd.checktime()
		end
	end,
	desc = "Check if we need to reload the file when it changed",
	group = "Checktime",
})

M.create_autocmd({ "TextYankPost" }, {
	callback = function()
		vim.hl.on_yank()
	end,
	desc = "Highlight on yank",
	group = "HighlightYank",
})

M.create_autocmd({ "VimEnter" }, {
	callback = function()
		vim.api.nvim_exec_autocmds("User", { pattern = "InitStatus" })
	end,
	group = "InitStatus",
	once = true,
})

M.create_autocmd({ "VimResized" }, {
	callback = function()
		local current_tab = vim.fn.tabpagenr()
		vim.cmd("tabdo wincmd =")
		vim.cmd("tabnext " .. current_tab)
	end,
	desc = "Resize splits if window got resized",
	group = "ResizeSplits",
})

M.create_autocmd({ "User" }, {
	callback = function(event)
		if Config.util.is_man(event.buf) then
			return
		end

		local stats = require("lazy").stats()
		local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
		local msg = ("%s loaded %s / %s plugins in %sms %s"):format(
			Config.icons.misc.lazy,
			stats.loaded,
			stats.count,
			ms,
			Config.icons.misc.lazy
		)

		vim.notify(msg)
	end,
	pattern = "LazyVimStarted",
	group = "StartupMessage",
})

if
	vim
		.opt
		.relativenumber--[[@as vim.Option]]
		:get()
then
	local relative_line_toggle_group = M.augroup("ToggleRelativeNumber", true)

	---@param win integer
	local function set_relnum_back(win)
		M.create_autocmd({ "CmdlineLeave" }, {
			callback = function()
				vim.wo[win].relativenumber = true
			end,
			group = relative_line_toggle_group,
			once = true,
		})
	end

	M.create_autocmd({ "CmdlineEnter" }, {
		callback = function()
			local win = vim.api.nvim_get_current_win()
			if vim.wo[win].relativenumber then
				vim.wo[win].relativenumber = false
				vim.cmd("redraw")
				set_relnum_back(win)
			end
		end,
		desc = "Disables `relativenumber` when entering command line mode and enables it again when leaving",
		group = relative_line_toggle_group,
	})

	M.create_autocmd({ "BufEnter", "FocusGained", "WinEnter", "InsertLeave" }, {
		callback = function(event)
			if Config.util.is_filetype_disabled(vim.bo[event.buf].filetype) then
				return
			end

			local lines = vim.api.nvim_buf_line_count(0)
			if lines < 20000 then
				local number_opt = vim.api.nvim_get_option_value("number", { scope = "local", win = 0 })
				if number_opt and vim.fn.mode() ~= "i" then
					vim.api.nvim_set_option_value("relativenumber", true, { scope = "local", win = 0 })
					vim.api.nvim_set_option_value("cursorline", true, { scope = "local", win = 0 })
				end
			end
		end,
		group = relative_line_toggle_group,
		desc = "Set relative number when focused",
	})

	M.create_autocmd({ "CmdlineEnter", "BufLeave", "FocusLost", "WinLeave", "InsertEnter" }, {
		callback = function()
			local nu = vim.api.nvim_get_option_value("number", { scope = "local", win = 0 })
			if nu and vim.fn.mode() ~= "i" then
				vim.api.nvim_set_option_value("relativenumber", false, { scope = "local", win = 0 })
			end
		end,
		desc = "Unset relative number when unfocused",
		group = relative_line_toggle_group,
	})
end

return M
