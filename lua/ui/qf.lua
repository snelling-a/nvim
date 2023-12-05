local Icons = require("ui.icons")

---@param info QfInfo
---@return table
function _G.quickfixtextfunc(info)
	local fn = vim.fn
	local items
	local qftf = {}
	local cols = vim.o.columns
	if info.quickfix == 1 then
		items = fn.getqflist({ id = info.id, items = 0 }).items
	else
		items = fn.getloclist(info.winid, { id = info.id, items = 0 }).items
		cols = vim.api.nvim_win_get_width(0)
	end
	local max_len = 0
	local fnames = {}
	for i = info.start_idx, info.end_idx do
		---@type E
		local e = items[i]
		local fname = ""
		if e.valid == 1 then
			if e.bufnr > 0 then
				fname = fn.bufname(e.bufnr) or ""
				if fname == "" then
					fname = "[No Name]"
				else
					fname = (fname or ""):gsub(("^%s"):format(vim.env.HOME), Icons.misc.tilde:gsub("%s", ""))
				end
				if #fname > max_len then
					max_len = #fname
				end
			end
			fnames[i] = fname
		end
	end
	local limit = math.min(math.max(20, math.floor(cols * 0.25)), max_len)

	local fnameFmt1 = ("%%-%ss"):format(limit)
	local fnameFmt2 = ("%s%%.%ss"):format(Icons.listchars.precedes, (limit - 1))
	local validFmt = "%s │%5d:%-3d│%s %s"
	for i = info.start_idx, info.end_idx do
		---@type E
		local e = items[i]
		local str
		local fname = fnames[i]
		if fname then
			if #fname <= limit then
				fname = fnameFmt1:format(fname)
			else
				fname = fnameFmt2:format(fname:sub(1 - limit))
			end
			local lnum = e.lnum > 99999 and -1 or e.lnum
			local col = e.col > 999 and -1 or e.col
			local qtype = ""
			if e.type ~= "" then
				qtype = (" %s"):format(Icons.diagnostics[e.type:sub(1, 1):upper()])
			end
			str = validFmt:format(fname, lnum, col, qtype, e.text)
		else
			str = e.text
		end
		table.insert(qftf, str)
	end
	return qftf
end

vim.o.quickfixtextfunc = "{info -> v:lua._G.quickfixtextfunc(info)}"
