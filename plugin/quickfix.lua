---@param str string
---@param width integer
---@return string
local function pad_right(str, width)
	return str .. string.rep(" ", width - #str)
end

---@param str string
---@param width integer
---@return string
local function pad_left(str, width)
	return string.rep(" ", width - #str) .. str
end

---@param info {quickfix: integer, id: integer, winid: integer, start_idx: integer, end_idx: integer}
---@return string[]
local function qftextfunc(info)
	---@type {bufnr: integer, lnum: integer, col: integer, end_col: integer, text: string}[]
	local items = info.quickfix == 1 and vim.fn.getqflist({ id = info.id, items = 0 }).items
		or vim.fn.getloclist(info.winid, { id = info.id, items = 0 }).items

	---@type {fname: string, loc: string, text: string}[]
	local entries = {}
	local max_fname = 0
	local max_loc = 0

	for i = info.start_idx, info.end_idx do
		local item = items[i]
		local fname = ""
		if item.bufnr > 0 then
			fname = vim.fn.bufname(item.bufnr)
			fname = vim.fn.fnamemodify(fname, ":~:.")
		end

		local loc = ""
		if item.lnum > 0 then
			if item.col > 0 then
				loc = string.format("%d:%d-%d", item.lnum, item.col, item.end_col or item.col)
			else
				loc = tostring(item.lnum)
			end
		end

		local text = item.text:gsub("^%s+", "")

		max_fname = math.max(max_fname, #fname)
		max_loc = math.max(max_loc, #loc)

		table.insert(entries, { fname = fname, loc = loc, text = text })
	end

	local lines = {}
	for _, entry in ipairs(entries) do
		local line = pad_right(entry.fname, max_fname) .. "│" .. pad_left(entry.loc, max_loc) .. "│ " .. entry.text
		table.insert(lines, line)
	end

	return lines
end

_G._qftextfunc = qftextfunc
vim.o.quickfixtextfunc = "v:lua._qftextfunc"
