---@class QFTFInfo
---@field quickfix number
---@field winid number
---@field id number
---@field start_idx number
---@field end_idx number

---@class qf.items.user_data
---@field range {start: {line: number, character: number}, end: {line: number, character: number}}
---@field uri string

---@class qf.items
---@field bufnr number
---@field col number
---@field end_col number
---@field end_lnum number
---@field lnum number
---@field module string
---@field nr number
---@field pattern string
---@field text string
---@field type string
---@field user_data qf.items.user_data
---@field valid number
---@field vcol number

---@param info QFTFInfo
---@return string[]
function _G.qftf(info)
	---@type table
	local items
	local ret = {}

	if info.quickfix == 1 then
		---@type qf.items[]
		items = vim.fn.getqflist({ id = info.id, items = 0 }).items
	else
		---@type qf.items[]
		items = vim.fn.getloclist(info.winid, { id = info.id, items = 0 }).items
	end
	local limit = 31
	local fnameFmt1, fnameFmt2 = "%-" .. limit .. "s", "…%." .. (limit - 1) .. "s"
	local validFmt = "%s "
		.. require("icons").fillchars.vert
		.. "%5d:%-3d"
		.. require("icons").fillchars.vert
		.. "%s %s"
	for i = info.start_idx, info.end_idx do
		local e = items[i]
		local fname = ""
		local str ---@type string
		if e.valid == 1 then
			if e.bufnr > 0 then
				fname = vim.fn.bufname(e.bufnr)
				if fname == "" then
					fname = "[No Name]"
				else
					---@type string
					fname = fname:gsub("^" .. vim.env.HOME, "~")
				end
				-- char in fname may occur more than 1 width, ignore this issue in order to keep performance
				if #fname <= limit then
					fname = fnameFmt1:format(fname)
				else
					fname = fnameFmt2:format(fname:sub(1 - limit))
				end
			end
			local lnum = e.lnum > 99999 and -1 or e.lnum
			local col = e.col > 999 and -1 or e.col
			local qtype = e.type == "" and "" or " " .. e.type:sub(1, 1):upper()
			str = validFmt:format(fname, lnum, col, qtype, e.text)
		else
			str = e.text
		end
		table.insert(ret, str)
	end
	return ret
end

vim.o.qftf = "{info -> v:lua._G.qftf(info)}"
