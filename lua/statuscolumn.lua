---@alias StatusColumn.Sign.type "mark"|"sign"|"fold"|"git"
---@alias StatusColumn.Sign {name:string, text:string, texthl:string, priority:number, type:StatusColumn.Sign.type}

---@class StatusColumn
---@overload fun(): string
local M = setmetatable({}, {
	---@param t StatusColumn
	---@return string
	__call = function(t)
		return t.get()
	end,
})

---@type table<number,table<number,StatusColumn.Sign[]>>
local sign_cache = {}
---@type table<string,string>
local cache = {}
---@type table<string,string>
local icon_cache = {}

local function setup()
	local timer = assert(vim.uv.new_timer())
	timer:start(50, 50, function()
		sign_cache = {}
		cache = {}
	end)
end

---@private
---@param name string
---@return boolean|nil
local function is_git_sign(name)
	if name:find("GitSign") then
		return true
	end
end

---@param buf number
---@return table<number, StatusColumn.Sign[]>
local function get_buf_signs(buf)
	---@type table<number, StatusColumn.Sign[]>
	local signs = {}

	local extmarks = vim.api.nvim_buf_get_extmarks(buf, -1, 0, -1, { details = true, type = "sign" })
	for _, extmark in pairs(extmarks) do
		local lnum = extmark[2] + 1
		signs[lnum] = signs[lnum] or {}
		local name = extmark[4].sign_hl_group or extmark[4].sign_name or ""

		table.insert(signs[lnum], {
			name = name,
			type = is_git_sign(name) and "git" or "sign",
			text = extmark[4].sign_text,
			texthl = extmark[4].sign_hl_group,
			priority = extmark[4].priority,
		})
	end

	local marks = vim.fn.getmarklist(buf)
	vim.list_extend(marks, vim.fn.getmarklist())
	for _, mark in ipairs(marks) do
		if mark.pos[1] == buf and mark.mark:match("[a-zA-Z]") then
			local lnum = mark.pos[2]
			signs[lnum] = signs[lnum] or {}
			table.insert(signs[lnum], { text = mark.mark:sub(2), texthl = "DiagnosticHint", type = "mark" })
		end
	end

	return signs
end

---@param win number
---@param buf number
---@param lnum number
---@return StatusColumn.Sign[]
local function line_signs(win, buf, lnum)
	local buf_signs = sign_cache[buf]
	if not buf_signs then
		buf_signs = get_buf_signs(buf)
		sign_cache[buf] = buf_signs
	end

	local signs = buf_signs[lnum] or {}

	vim.api.nvim_win_call(win, function()
		if vim.fn.foldclosed(lnum) >= 0 then
			signs[#signs + 1] = { text = vim.opt.fillchars:get().foldclose, texthl = "Folded", type = "fold" }
		end
	end)

	table.sort(signs, function(a, b)
		return (a.priority or 0) > (b.priority or 0)
	end)

	return signs
end

---@private
---@param sign? StatusColumn.Sign
---@return string
local function get_icon(sign)
	if not sign then
		return "  "
	end
	local key = (sign.text or "") .. (sign.texthl or "")
	if icon_cache[key] then
		return icon_cache[key]
	end
	local text = vim.fn.strcharpart(sign.text or "", 0, 2) ---@type string
	text = text .. string.rep(" ", 2 - vim.fn.strchars(text))
	icon_cache[key] = sign.texthl and ("%#" .. sign.texthl .. "#" .. text .. "%*") or text
	return icon_cache[key]
end

---@return string
local function _get()
	setup()
	local win = vim.g.statusline_winid
	local show_signs = vim.v.virtnum == 0 and vim.wo[win].signcolumn ~= "no"
	local line_number = '%=%{%(&number || &relativenumber) && v:virtnum == 0 ? ("%l") : ""%} '
	local components = { "", line_number, "" }

	if show_signs then
		local buf = vim.api.nvim_win_get_buf(win)
		local is_file = vim.bo[buf].buftype == ""
		local signs = line_signs(win, buf, vim.v.lnum)

		if #signs > 0 then
			---@type table<StatusColumn.Sign.type,StatusColumn.Sign>
			local signs_by_type = {}
			for _, s in ipairs(signs) do
				signs_by_type[s.type] = signs_by_type[s.type] or s
			end

			---@param types StatusColumn.Sign.type[]
			---@return StatusColumn.Sign|nil
			local function find(types)
				for _, t in ipairs(types) do
					if signs_by_type[t] then
						return signs_by_type[t]
					end
				end
			end

			local left_c = { "mark", "sign" }
			local right_c = { "fold", "git" }
			local left, right = find(left_c), find(right_c)

			local git = signs_by_type.git
			if git and left and left.type == "fold" then
				left.texthl = git.texthl
			end
			if git and right and right.type == "fold" then
				right.texthl = git.texthl
			end

			components[1] = left and get_icon(left) or "  "
			components[3] = is_file and (right and get_icon(right) or "  ") or ""
		else
			components[1] = "  "
			components[3] = is_file and Config.icons.fillchars.foldsep .. " " or ""
		end
	end

	return table.concat(components, "")
end

function M.get()
	local win = vim.g.statusline_winid
	local buf = vim.api.nvim_win_get_buf(win)
	local key = ("%d:%d:%d:%d"):format(win, buf, vim.v.lnum, vim.v.virtnum and 1 or 0)
	if cache[key] then
		return cache[key]
	end

	local okay, sign = pcall(_get)
	if okay then
		cache[key] = sign
		return sign
	end

	return ""
end

return M
