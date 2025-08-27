---@class Statuscolumn
local M = {}

---@alias Statuscolumn.sign.type "mark"|"sign"|"fold"|"git"
---@alias Statuscolumn.sign {name:string, text:string, texthl:string, priority:number, type:Statuscolumn.sign.type}

-- Cache for signs per buffer and line
---@type table<number,table<number,Statuscolumn.sign[]>>
local sign_cache = {}
---@type table<string,string>
local cache = {}
---@type table<string,string>
local icon_cache = {}

local did_setup = false

local function setup()
	if did_setup then
		return
	end
	did_setup = true

	local timer = assert((vim.uv or vim.loop).new_timer())

	timer:start(40, 40, function()
		sign_cache = {}
		cache = {}
	end)
end

---@param name string
---@return boolean
local function is_git_sign(name)
	for _, pattern in ipairs({ "GitSign", "MiniDiffSign" }) do
		if name:find(pattern) then
			return true
		end
	end

	return false
end

-- Returns a list of regular and extmark signs sorted by priority (low to high)
---@param buf number
---@return Statuscolumn.sign[]
local function get_buf_signs(buf)
	---@type table<number, Statuscolumn.sign[]>
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
			table.insert(signs[lnum], { text = mark.mark:sub(2), texthl = "@comment", type = "mark" })
		end
	end

	return signs
end

-- Returns a list of regular and extmark signs sorted by priority (high to low)
---@param win number
---@param buf number
---@param lnum number
---@return Statuscolumn.sign[]
local function get_line_signs(win, buf, lnum)
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

---@param sign? Statuscolumn.sign
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
local function build_statusline()
	if not did_setup then
		setup()
	end

	local win = vim.g.statusline_winid
	local show_signs = vim.v.virtnum == 0 and vim.wo[win].signcolumn ~= "no"
	local components = { "", "%l", "" } -- left, middle, right
	if not show_signs and not (vim.wo[win].number or vim.wo[win].relativenumber) then
		return ""
	end

	if show_signs then
		local buf = vim.api.nvim_win_get_buf(win)
		local is_file = vim.bo[buf].buftype == ""
		local signs = get_line_signs(win, buf, vim.v.lnum)

		if #signs > 0 then
			local signs_by_type = {} ---@type table<Statuscolumn.sign.type,Statuscolumn.sign>
			for _, sign in ipairs(signs) do
				signs_by_type[sign.type] = signs_by_type[sign.type] or sign
			end

			---@param types Statuscolumn.sign.type[]
			---@return Statuscolumn.sign|nil
			local function find(types)
				for _, type in ipairs(types) do
					if signs_by_type[type] then
						return signs_by_type[type]
					end
				end
			end

			local right_components = { "mark", "sign" }
			local left_components = { "fold", "git" }

			local left_component = find(right_components)
			local right_component = find(left_components)

			components[1] = left_component and get_icon(left_component) or "  "
			components[3] = is_file and (right_component and get_icon(right_component) or "  ") or ""
		else
			components[1] = "  "
			components[3] = is_file and "  " or ""
		end
	end

	return table.concat(components, "")
end

function M.get()
	local win = vim.g.statusline_winid
	local buf = vim.api.nvim_win_get_buf(win)
	local key = ("%d:%d:%d:%d"):format(win, buf, vim.v.lnum, vim.v.virtnum ~= 0 and 1 or 0)
	if cache[key] then
		return cache[key]
	end
	local ok, statusline = pcall(build_statusline)
	if ok then
		cache[key] = statusline
		return statusline
	end
	return ""
end

return M
