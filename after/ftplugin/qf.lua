vim.opt_local.cursorline = true
vim.opt_local.number = false
vim.opt_local.relativenumber = false
vim.opt_local.signcolumn = "no"
vim.opt_local.wrap = false
vim.opt_local.spell = false
vim.opt_local.buflisted = false

-- Disable default qf syntax
vim.cmd("syntax clear")

-- Highlight filename, separators, and line numbers
vim.fn.matchadd("Directory", "^[^│]*")
vim.fn.matchadd("Delimiter", "│")
vim.fn.matchadd("LineNr", "│\\zs[^│]*\\ze│")

-- Apply treesitter highlighting to the text portion
local function apply_ts_highlights()
	local bufnr = vim.api.nvim_get_current_buf()
	if vim.bo[bufnr].buftype ~= "quickfix" then
		return
	end

	local ns = vim.api.nvim_create_namespace("qf_treesitter")
	vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

	local is_loc = vim.fn.getloclist(0, { filewinid = 0 }).filewinid ~= 0
	local items = is_loc and vim.fn.getloclist(0) or vim.fn.getqflist()
	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

	for i, line in ipairs(lines) do
		local item = items[i]
		if not item or item.bufnr == 0 then
			goto continue
		end

		-- Find where the text starts (after second separator + space)
		local sep = "│"
		local first_sep = line:find(sep, 1, true)
		if not first_sep then
			goto continue
		end
		local second_sep = line:find(sep, first_sep + #sep, true)
		if not second_sep then
			goto continue
		end
		local text_start_byte = second_sep + #sep + 1 -- after │ and space

		local text = line:sub(text_start_byte)
		if text == "" then
			goto continue
		end

		-- Get filetype from source buffer
		if not vim.api.nvim_buf_is_valid(item.bufnr) then
			goto continue
		end
		local ft = vim.bo[item.bufnr].filetype
		if ft == "" then
			-- Try to get filetype from filename
			local fname = vim.fn.bufname(item.bufnr)
			ft = vim.filetype.match({ filename = fname }) or ""
		end
		local lang = vim.treesitter.language.get_lang(ft)
		if not lang or not pcall(vim.treesitter.language.inspect, lang) then
			goto continue
		end

		-- Parse and highlight
		local ok, parser = pcall(vim.treesitter.get_string_parser, text, lang)
		if not ok then
			goto continue
		end

		local tree = parser:parse()[1]
		if not tree then
			goto continue
		end

		local query = vim.treesitter.query.get(lang, "highlights")
		if not query then
			goto continue
		end

		for id, node in query:iter_captures(tree:root(), text, 0, -1) do
			local name = query.captures[id]
			local hl = "@" .. name .. "." .. lang
			if vim.fn.hlexists(hl) == 0 then
				hl = "@" .. name
			end
			local start_row, start_col, _, end_col = node:range()
			if start_row == 0 then
				vim.api.nvim_buf_set_extmark(bufnr, ns, i - 1, text_start_byte - 1 + start_col, {
					end_col = text_start_byte - 1 + end_col,
					hl_group = hl,
					priority = 200,
				})
			end
		end

		::continue::
	end
end

vim.schedule(apply_ts_highlights)

vim.api.nvim_create_autocmd("BufWinEnter", {
	buffer = 0,
	callback = function()
		vim.schedule(apply_ts_highlights)
	end,
})

local function qf_statusline()
	local is_loc = vim.fn.getloclist(0, { filewinid = 0 }).filewinid ~= 0
	local info = is_loc and vim.fn.getloclist(0, { title = 0, size = 0 }) or vim.fn.getqflist({ title = 0, size = 0 })
	local title = info.title ~= "" and info.title or (is_loc and "Location List" or "Quickfix")
	local count = info.size or 0
	return string.format(" %s [%d]%%=%%l/%%L ", title, count)
end

_G._qf_statusline = qf_statusline
vim.opt_local.statusline = "%{%v:lua._qf_statusline()%}"

local function close_and_return()
	local prev_win = vim.fn.win_getid(vim.fn.winnr("#"))
	vim.cmd.cclose()
	vim.cmd.lclose()
	if prev_win ~= 0 and vim.api.nvim_win_is_valid(prev_win) then
		vim.api.nvim_set_current_win(prev_win)
	end
end

local function is_loclist()
	return vim.fn.getloclist(0, { filewinid = 0 }).filewinid ~= 0
end

local function get_entry()
	local list = is_loclist() and vim.fn.getloclist(0) or vim.fn.getqflist()
	return list[vim.fn.line(".")]
end

local function open_entry(cmd)
	local entry = get_entry()
	if not entry or entry.bufnr == 0 then
		return
	end

	close_and_return()
	if cmd then
		vim.cmd(cmd)
	end
	vim.cmd.buffer(entry.bufnr)
	vim.api.nvim_win_set_cursor(0, { entry.lnum, math.max(0, entry.col - 1) })
	vim.cmd.normal({ "zv", bang = true })
end

vim.keymap.set({ "n" }, "<C-v>", function()
	open_entry("vsplit")
end, { buffer = true, desc = "Open in vertical split" })
vim.keymap.set({ "n" }, "<C-s>", function()
	open_entry("split")
end, { buffer = true, desc = "Open in horizontal split" })
vim.keymap.set({ "n" }, "<C-t>", function()
	open_entry("tabnew")
end, { buffer = true, desc = "Open in new tab" })
vim.keymap.set({ "n" }, "<CR>", open_entry, { buffer = true, desc = "Open entry and close" })
vim.keymap.set({ "n" }, "q", close_and_return, { buffer = true, nowait = true, desc = "Close window" })
