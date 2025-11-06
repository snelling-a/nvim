local M = {}

---@type string[][]
local bool_groups = {
	{ "0", "1" },
	{ "True", "False" },
	{ "jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec" },
	{
		"january",
		"february",
		"march",
		"april",
		"may",
		"june",
		"july",
		"august",
		"september",
		"october",
		"november",
		"december",
	},
	{ "left", "right" },
	{ "let", "const" },
	{ "mon", "tue", "wed", "thu", "fri", "sat", "sun" },
	{ "monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday" },
	{ "null", "undefined" },
	{ "on", "off" },
	{ "private", "public" },
	{ "top", "bottom" },
	{ "true", "false" },
	{ "||", "&&" },
}

---@type string[]
local all_words = {}
for _, group in ipairs(bool_groups) do
	for _, word in ipairs(group) do
		all_words[#all_words + 1] = word
	end
end

---@param str string?
---@return boolean
local function is_capitalized(str)
	if not str or #str == 0 then
		return false
	end
	return str:sub(1, 1):match("%u")
end

---@param original string?
---@param replacement string
---@return string
local function with_case(original, replacement)
	if is_capitalized(original) then
		return replacement:sub(1, 1):upper() .. replacement:sub(2)
	else
		return replacement
	end
end

---@param word string?
---@return string[]|nil, integer?  Returns the cycle and the index of the token
local function find_group(word)
	if not word or #word == 0 then
		return
	end
	local lowercase = word:lower()
	for _, group in ipairs(bool_groups) do
		for i, match in ipairs(group) do
			if match == lowercase then
				return group, i
			end
		end
	end
end

-- Get word bounds around cursor via \k (respects 'iskeyword')
---@param line string
---@param column number
---@return integer?, integer?, string?
local function find_keyword_bounds(line, column)
	local col = column + 1
	---@type {[1]:string,[2]:integer,[3]:integer}
	local match = vim.fn.matchstrpos(line, [[\k*\%]] .. col .. [[c\k*]])
	local word, match_start, match_end = match[1], match[2], match[3]
	if word ~= "" then
		return match_start, match_end, word
	end
end

-- For non-keyword tokens (e.g. "||", "&&"), search around cursor
---@param line string
---@param column any
---@return integer?,integer?,string?
---@return nil
local function find_symbol_bounds(line, column)
	---@type { s:integer, e:integer, tok:string, len:integer }
	local best
	for _, tok in ipairs(all_words) do
		if tok:find("[^%w_]") then
			local len = #tok
			local start_min = math.max(0, column - len + 1)
			local start_max = column
			for s = start_min, start_max do
				local e = s + len
				if e <= #line and line:sub(s + 1, e) == tok and column >= s and column < e then
					if not best or len > best.len then
						best = { s = s, e = e, tok = tok, len = len }
					end
				end
			end
		end
	end
	if best then
		return best.s, best.e, best.tok
	end
end

---@param row number 0-based line index
---@param column number 0-based column index
---@return integer?, integer?, string?
local function find_under_cursor(row, column)
	local line = vim.api.nvim_buf_get_lines(0, row, row + 1, true)[1]
	if not line then
		return
	end

	local word_start, word_end, word = find_keyword_bounds(line, column)
	if word_start then
		local group = find_group(word)
		if group then
			return word_start, word_end, word
		end
	end

	-- Then symbols like || / &&
	return find_symbol_bounds(line, column)
end

---@param direction number 1 for next, -1 for previous
local function flip(direction)
	local cursor = vim.api.nvim_win_get_cursor(0)
	local cursor_row, cursor_column = cursor[1] - 1, cursor[2]

	local s, e, tok = find_under_cursor(cursor_row, cursor_column)
	if not s then
		return
	end

	local cyc, idx = find_group(tok)
	if not cyc then
		return
	end

	local new_idx = ((idx - 1 + direction) % #cyc) + 1
	local repl = with_case(tok, cyc[new_idx])

	---@cast e integer
	vim.api.nvim_buf_set_text(0, cursor_row, s, cursor_row, e, { repl })
	vim.api.nvim_win_set_cursor(0, { cursor_row + 1, s })
end

function M.flip_next()
	flip(1)
end
function M.flip_prev()
	flip(-1)
end

return M
