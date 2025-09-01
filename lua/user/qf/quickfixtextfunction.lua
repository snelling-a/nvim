local Icons = require("icons")

local MAX_FILE_WIDTH = 50
local max_file, max_lnum, max_col = 0, 0, 0

---@param info QFTFInfo
---@return qflist
local function get_list(info)
	if info.quickfix == 1 then
		return vim.fn.getqflist({ id = info.id, items = 1, qfbufnr = 1 })
	else
		return vim.fn.getloclist(info.winid, { id = info.id, items = 1, qfbufnr = 1 })
	end
end
local namespace = vim.api.nvim_create_namespace("nvim.qf.qftf")

---@param bufnr integer
---@param highlights QFHL[]
local function apply_highlights(bufnr, highlights)
	for i = 1, #highlights do
		local hl = highlights[i]
		vim.hl.range(bufnr, namespace, hl.group, { hl.line, hl.col }, { hl.line, hl.end_col })
	end
end

---@param filename string
---@return string
local function get_filename(filename)
	local fnameFmt1, fnameFmt2 = "%-" .. max_file .. "s", "…%." .. (max_file - 1) .. "s"
	filename = tostring(filename or "")

	if filename == "" then
		filename = "[No Name]"
	else
		---@type string
		filename = filename:gsub("^" .. vim.env.HOME, "~")
	end

	if #filename > MAX_FILE_WIDTH then
		filename = fnameFmt2:format(filename:sub(1 - MAX_FILE_WIDTH))
	else
		filename = fnameFmt1:format(filename)
	end

	return filename
end

---@class user.qf.quickfixtextfunction
---@param info QFTFInfo
---@return string[]
return function(info)
	local list = get_list(info)
	---@type QFLine[]
	local items = {}

	if info.start_idx == 1 then
		vim.api.nvim_buf_clear_namespace(list.qfbufnr, namespace, 0, -1)
	end

	for i = info.start_idx, info.end_idx do
		local raw = list.items[i]
		if raw.valid == 1 then
			---@type QFLine
			local item = {
				col = tostring(raw.col or 0),
				filename = vim.fn.bufname(raw.bufnr),
				lnum = tostring(raw.lnum or 0),
				text = raw.text and vim.trim(raw.text) or "",
				type = raw.type or "",
			}

			if raw.lnum and raw.lnum > 0 then
				---@type string|number
				local lnum = raw.lnum
				if raw.end_lnum and raw.end_lnum > 0 and raw.end_lnum ~= lnum then
					lnum = lnum .. "-" .. raw.end_lnum
				end
				item.lnum = tostring(lnum)

				if raw.col and raw.col > 0 then
					---@type string|number
					local col = raw.col
					if raw.end_col and raw.end_col > 0 and raw.end_col ~= col then
						col = col .. "-" .. raw.end_col
					end
					item.col = tostring(col)
				end
			end

			table.insert(items, item)

			max_file = math.min(MAX_FILE_WIDTH, math.max(max_file, #item.filename))
			max_lnum, max_col = math.max(max_lnum, #item.lnum), math.max(max_col, #item.col)
		end
	end

	---@type string[]
	local lines = {}
	local highlights = {}

	for i, item in ipairs(items) do
		local type = Icons.qf.type_mapping[item.type]
		local icon = "" --(type and type.text or " ") .. "  "
		local divider = Icons.fillchars.vert .. " "
		local filename = get_filename(item.filename)
		local pt1 = icon .. string.format("%-" .. max_file .. "s ", filename) .. divider
		local pt2 = string.format("%" .. max_lnum .. "s", (item.lnum or ""))
			.. ":"
			.. string.format("%-" .. max_col .. "s", tostring(item.col or ""))
			.. " "
			.. divider

		local line = pt1 .. pt2 .. tostring(item.text)

		if line == "" then
			line = " "
		end

		---@param group string
		---@param col integer
		---@param end_col integer
		local function hl(group, col, end_col)
			table.insert(highlights, { group = group, line = i - 1, col = col, end_col = end_col })
		end

		if type and icon ~= "   " then
			hl(type.hl, 0, #icon)
		end

		local from, to = filename:find(".*/")
		if from and to then
			hl("Comment", #icon + from - 1, #icon + to)
		end

		hl("Directory", #icon + (to and to or 0), #icon + #filename)
		hl("NonText", #icon + #item.filename + 1, #pt1 + 1)

		local end_of_location = #pt1 + #pt2 - (#divider + 1)

		hl("Number", #pt1, end_of_location)
		hl("NonText", end_of_location, #pt1 + #pt2)
		hl(type and type.hl or "PMenu", #pt1 + #pt2, -1)

		table.insert(lines, line)
	end

	if info.start_idx == 1 then
		vim.schedule(function()
			apply_highlights(list.qfbufnr, highlights)
		end)
	end

	return lines
end
