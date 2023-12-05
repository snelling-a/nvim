local Icons = require("ui.icons")

local M = setmetatable({}, {
	__call = function(self)
		return self.init()
	end,
})

M.basic = ("%%#NonText#%%{&nu?(&rnu&&v:relnum?v:relnum:v:lnum):''}%%=%s%%T"):format(
	require("ui.icons").misc.leadmultispace
) --[[@as vim.opt.statuscolumn]]

---@param bufnr integer buffer number
---@return Sign[]
function M.get_signs(bufnr)
	local lnum = vim.v.lnum

	---@type Sign[]
	local signs = vim.tbl_map(function(sign)
		---@type Sign
		local s = vim.fn.sign_getdefined(sign.name)[1] or {}
		s.priority = sign.priority

		return s
	end, vim.fn.sign_getplaced(bufnr, { group = "*", lnum = lnum })[1].signs)

	local extmarks = vim.api.nvim_buf_get_extmarks(
		bufnr,
		-1,
		{ lnum - 1, 0 },
		{ lnum - 1, -1 },
		{ details = true, type = "sign" }
	)

	for _, extmark in pairs(extmarks) do
		signs[#signs + 1] = {
			name = extmark[4].sign_hl_group or "",
			text = extmark[4].sign_text,
			texthl = extmark[4].sign_hl_group,
			priority = extmark[4].priority,
		}
	end

	table.sort(signs, function(a, b)
		return (a.priority or 0) < (b.priority or 0)
	end)

	return signs
end

function M.get_line_numbers()
	local v
	if vim.v.virtnum > 0 then
		v = ("%s "):format(Icons.misc.wrap)
	elseif vim.v.virtnum < 0 then
		v = " "
	else
		v = [[%{&nu?(&rnu&&v:relnum?v:relnum:v:lnum):''} ]]
	end
	return ("%%=%s"):format(v)
end

---@param sign Sign
---@param len? number
function M.make_icon(sign, len)
	sign = sign or {}
	len = len or 1
	local strcharpart = vim.fn.strcharpart(sign.text or "", 0, len) ---@type string
	local strchars = len - vim.fn.strchars(strcharpart)
	local text = ("%s%s"):format(strcharpart, string.rep(" ", strchars))
	return sign.texthl and ("%%#%s#%s%%*"):format(sign.texthl, text) or text
end

function M.get_gitsign(git_sign)
	if git_sign then
		return M.make_icon({ texthl = git_sign.texthl, text = string.gsub(git_sign.text, "%s+", "") })
	else
		return ("%%#LineNr#%s"):format(Icons.fillchars.foldsep)
	end
end

function M.get_fold()
	local win = vim.g.statusline_winid
	local fold = {}
	vim.api.nvim_win_call(win, function()
		if vim.fn.foldclosed(vim.v.lnum) >= 0 then
			fold = { text = vim.opt.fillchars:get().foldclose or Icons.fillchars.foldclose, texthl = "FoldColumn" }
		end
	end)
	return fold.text and M.make_icon(fold) or nil
end

---@param buf number
---@param lnum number
function M.get_mark(buf, lnum)
	local marks = vim.fn.getmarklist(buf)
	vim.list_extend(marks, vim.fn.getmarklist())
	for _, mark in ipairs(marks) do
		if mark.pos[1] == buf and mark.pos[2] == lnum and mark.mark:match("[a-zA-Z]") then
			return M.make_icon({ text = mark.mark:sub(2), texthl = "DiagnosticHint" })
		end
	end
end

function M.init()
	local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)

	local sign, git_sign
	for _, s in ipairs(M.get_signs(bufnr)) do
		if s.name and s.name:find("GitSign") then
			git_sign = s
		else
			sign = s
		end
	end

	local components = {
		M.get_fold() or M.get_mark(bufnr, vim.v.lnum) or "",
		M.make_icon(sign),
		M.get_line_numbers(),
		M.get_gitsign(git_sign),
	}

	return table.concat(components, "")
end

return M
