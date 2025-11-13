local Util = require("util")
local M = {}

---@type string[][]
local bool_groups = {
	{ "0", "1" },
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

-- Check if first letter is capitalized
---@param str string?
---@return boolean
local function is_capitalized(str)
	if not str or #str == 0 then
		return false
	end
	return Util.capitalize_first_letter(str) == str
end

---@param original string?
---@param replacement string
---@return string replacement with case adjusted
local function with_case(original, replacement)
	if is_capitalized(original) then
		return Util.capitalize_first_letter(replacement)
	end

	return replacement
end

---@param word string?
---@return string[]|nil group Bool group containing word
---@return integer|nil index Index of word in group
local function find_group(word)
	if not word or #word == 0 then
		return
	end
	local lowercase = word:lower()
	for _, group in ipairs(bool_groups) do
		for index, match in ipairs(group) do
			if match == lowercase then
				return group, index
			end
		end
	end
end

-- Get word bounds around cursor via \k (respects 'iskeyword')
---@param line string
---@param column number
---@return integer? word_start, integer? word_end, string? word
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
---@return integer? word_start, integer? word_end, string? word
---@return nil
local function find_symbol_bounds(line, column)
	---@type { word_start:integer, word_end:integer, word:string, length:integer }
	local best
	for _, word in ipairs(all_words) do
		if word:find("[^%w_]") then
			local length = #word
			local start_min = math.max(0, column - length + 1)
			local start_max = column
			for word_start = start_min, start_max do
				local word_end = word_start + length
				if
					word_end <= #line
					and line:sub(word_start + 1, word_end) == word
					and column >= word_start
					and column < word_end
				then
					if not best or length > best.length then
						best = { word_start = word_start, word_end = word_end, word = word, length = length }
					end
				end
			end
		end
	end
	if best then
		return best.word_start, best.word_end, best.word
	end
end

---@param row number 0-based line index
---@param column number 0-based column index
---@return integer? word_start, integer? word_end, string? word
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

	local word_start, word_end, word = find_under_cursor(cursor_row, cursor_column)
	if not word_start then
		return
	end

	local group, index = find_group(word)
	if not group then
		return
	end

	local new_index = ((index - 1 + direction) % #group) + 1
	local replacement = with_case(word, group[new_index])

	---@cast word_end integer
	vim.api.nvim_buf_set_text(0, cursor_row, word_start, cursor_row, word_end, { replacement })
	vim.api.nvim_win_set_cursor(0, { cursor_row + 1, word_start })
end

function M.flip_next()
	flip(1)
end
function M.flip_prev()
	flip(-1)
end

return M
