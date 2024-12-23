local group = vim.api.nvim_create_augroup("cloak", {})
local namespace = vim.api.nvim_create_namespace("cloak")

local M = {}

M.enabled = true

M.cloak_character = "*"
M.cloak_length = nil
M.file_pattern = { ".env*", "docker-compose*" }
---@type{file_pattern: string|table<string>, cloak_pattern: string|table<string>, replace: string?}[]
M.pattern = {
	cloak_pattern = "=.+",
	replace = nil,
}
M.uncloaked_line_num = nil
M.cloak_on_leave = false

---@param bufnr integer
function M.create_user_commands(bufnr)
	vim.api.nvim_buf_create_user_command(bufnr, "CloakEnable", M.enable, {})
	vim.api.nvim_buf_create_user_command(bufnr, "CloakDisable", M.disable, {})
	vim.api.nvim_buf_create_user_command(bufnr, "CloakToggle", M.toggle, {})
	vim.api.nvim_buf_create_user_command(bufnr, "CloakPreviewLine", M.uncloak_line, {})
end

M.setup = function()
	vim.b.cloak_enabled = M.enabled

	M.pattern.cloak_pattern = { M.pattern.cloak_pattern, replace = M.pattern.replace }

	vim.api.nvim_create_autocmd({ "BufEnter", "TextChanged", "TextChangedI", "TextChangedP" }, {
		pattern = M.file_pattern,
		callback = function(event)
			if M.enabled then
				M.cloak(M.pattern)
			else
				M.uncloak()
			end

			M.create_user_commands(event.buf)
		end,
		group = group,
	})

	vim.api.nvim_create_autocmd("BufWinLeave", {
		pattern = M.file_pattern,
		callback = function()
			M.enable()
		end,
		group = group,
	})
end

M.uncloak = function()
	vim.api.nvim_buf_clear_namespace(0, namespace, 0, -1)
end

M.uncloak_line = function()
	if not M.enabled then
		return
	end

	local buf = vim.api.nvim_win_get_buf(0)
	local cursor = vim.api.nvim_win_get_cursor(0)
	M.uncloaked_line_num = cursor[1]

	vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "BufLeave" }, {
		buffer = buf,
		callback = function(args)
			if not M.enabled then
				M.uncloaked_line_num = nil
				return true
			end

			if args.event == "BufLeave" then
				M.uncloaked_line_num = nil
				M.recloak_file(vim.api.nvim_buf_get_name(buf))
				return true
			end

			local ncursor = vim.api.nvim_win_get_cursor(0)
			if ncursor[1] == M.uncloaked_line_num then
				return
			end

			M.uncloaked_line_num = nil
			M.recloak_file(vim.api.nvim_buf_get_name(buf))

			-- deletes the auto command
			return true
		end,
		group = group,
	})

	M.recloak_file(vim.api.nvim_buf_get_name(buf))
end

M.cloak = function(pattern)
	M.uncloak()

	local function determine_replacement(length, prefix)
		local cloak_str = prefix .. M.cloak_character:rep(tonumber(M.cloak_length) or length - vim.fn.strchars(prefix))
		local remaining_length = length - vim.fn.strchars(cloak_str)
		-- Fixme:
		-- - When cloak_length is longer than the text underlying it,
		--   it results in overlaying of extra text
		-- => Possiblie solutions would could be implemented using inline virtual text
		--    (https://github.com/neovim/neovim/pull/20130)
		return cloak_str -- :sub(1, math.min(remaining_length - 1, -1))
			.. (" "):rep(remaining_length)
	end

	local found_pattern = false
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	for i, line in ipairs(lines) do
		-- Find all matches for the current line
		local searchStartIndex = 1
		while
			searchStartIndex < #line -- if the line is uncloaked skip
			and i ~= M.uncloaked_line_num
		do
			-- Find best pattern based on starting position and tiebreak with length
			local first, last, matching_pattern, has_groups = -1, 1, nil, false
			local current_first, current_last, capture_group = line:find(pattern.cloak_pattern[1], searchStartIndex)
			if
				current_first ~= nil
				and (first < 0 or current_first < first or (current_first == first and current_last > last))
			then
				first, last, matching_pattern, has_groups =
					current_first, current_last, pattern.cloak_pattern, capture_group ~= nil
			end

			if first >= 0 then
				found_pattern = true
				local prefix = line:sub(first, first)
				if has_groups and matching_pattern.replace ~= nil then
					prefix = line:sub(first, last):gsub(matching_pattern[1], matching_pattern.replace, 1)
				end
				local last_of_prefix = first + vim.fn.strchars(prefix) - 1
				if prefix == line:sub(first, last_of_prefix) then
					first, prefix = last_of_prefix + 1, ""
				end
				vim.api.nvim_buf_set_extmark(0, namespace, i - 1, first - 1, {
					hl_mode = "combine",
					virt_text = {
						{ determine_replacement(last - first + 1, prefix), "Comment" },
					},
					virt_text_pos = "overlay",
				})
			else
				break
			end
			searchStartIndex = last
		end
	end
	if found_pattern then
		vim.opt_local.wrap = false
	end
end

M.recloak_file = function(filename)
	local base_name = vim.fn.fnamemodify(filename, ":t")

	for _, file_pattern in ipairs(M.file_patterns) do
		if base_name ~= nil and vim.fn.match(base_name, vim.fn.glob2regpat(file_pattern)) ~= -1 then
			M.cloak(M.pattern)
			return true
		end
	end

	return false
end

M.disable = function()
	M.uncloak()
	M.enabled = false
	vim.b.cloak_enabled = false
end

M.enable = function()
	M.enabled = true
	vim.b.cloak_enabled = true
	vim.cmd("doautocmd TextChanged")
end

M.toggle = function()
	if M.enabled then
		M.disable()
	else
		M.enable()
	end
end

M.setup()
return M
