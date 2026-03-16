---@class TabData
---@field name string
---@field page integer
---@field bufnr integer
---@field winnr integer

---@param str string
---@return integer
local function len(str)
	return vim.fn.strdisplaywidth(str)
end

---@type string
local MORE = vim.opt.listchars:get().extends
local LEN_PAD = len(MORE)
local hl_more = "%#TabLine#" .. MORE
local path_alias_cache = { buf_list = nil, aliases = nil }

---@param str string
---@param max_width integer
---@param from_end? boolean
---@return string
local function truncate_by_display_width(str, max_width, from_end)
	assert(max_width > 0)

	local current_width = vim.fn.strdisplaywidth(str)
	if current_width <= max_width then
		return str
	end

	if from_end then
		local num_chars = #str
		while num_chars > 0 and vim.fn.strdisplaywidth(vim.strcharpart(str, num_chars - 1)) > max_width do
			num_chars = num_chars - 1
		end
		return vim.strcharpart(str, num_chars)
	else
		local num_chars = 0
		while num_chars < #str and vim.fn.strdisplaywidth(vim.strcharpart(str, 0, num_chars + 1)) <= max_width do
			num_chars = num_chars + 1
		end
		return vim.strcharpart(str, 0, num_chars)
	end
end

---@param tabpage integer
---@return integer, integer
local function fetch_winnr_bufnr(tabpage)
	local winnr = vim.api.nvim_tabpage_get_win(tabpage)
	local bufnr = vim.api.nvim_win_get_buf(winnr)

	return winnr, bufnr
end

---@param bufnr integer
---@return string
local function fetch_buf_name(bufnr)
	local buf = vim.bo[bufnr]

	local buftype = buf.buftype
	local filetype = buf.filetype

	local buf_name = vim.api.nvim_buf_get_name(bufnr)

	if buftype == "terminal" then
		local title = vim.b[bufnr].term_title
		return "  " .. title:gsub("~/.*/", "")
	elseif filetype == "checkhealth" then
		return "Checkhealth"
	elseif filetype == "qf" then
		return "QuickFix"
	elseif filetype == "mason" then
		return "Mason"
	elseif filetype == "help" and not buf.modifiable then
		return " " .. vim.fn.fnamemodify(buf_name, ":t")
	elseif buf_name == "kulala://ui" then
		return "Kulala"
	elseif vim.startswith(buf_name, "codediff://") then
		return vim.fn.fnamemodify(buf_name, ":t")
	elseif buf_name == "" then
		return "[No Name]"
	elseif buftype == "" then
		local relative_path = vim.fn.fnamemodify(buf_name, ":.")

		return relative_path
	else
		return buf_name
	end
end

---@param paths string[]
---@return table<string, string>
local function calculate_unambiguous_paths(paths)
	---@type table<string, boolean>
	local path_set = {}
	for _, path in ipairs(paths) do
		path_set[path] = true
	end

	---@type string[]
	local unique_paths = {}
	for path, _ in pairs(path_set) do
		unique_paths[#unique_paths + 1] = path
	end

	---@type table<string, string[]>
	local path_parts = {}
	for _, path in ipairs(unique_paths) do
		path_parts[path] = vim.split(path, "/")
	end

	---@type integer
	local max_iterations = 0
	for _, parts in pairs(path_parts) do
		max_iterations = math.max(max_iterations, #parts)
	end

	---@type table<string, integer>
	local path_to_level = {}
	for _, path in ipairs(unique_paths) do
		path_to_level[path] = 1
	end

	---@type table<string, string>
	local aliases = {}
	---@type table<string, string>
	local results = {}

	local ambiguous_paths = vim.deepcopy(unique_paths)

	local iteration = 0
	while #ambiguous_paths > 0 and iteration < max_iterations do
		iteration = iteration + 1

		-- Aliases for the current level
		for _, path in ipairs(ambiguous_paths) do
			local parts = path_parts[path]
			local level = path_to_level[path]

			---@type string[]
			local alias_parts = {}

			local start = math.max(1, #parts - level + 1)
			for i = start, #parts do
				alias_parts[#alias_parts + 1] = parts[i]
			end

			aliases[path] = table.concat(alias_parts, "/")
		end

		-- Count aliases occurrences among the ambiguous set
		---@type table<string, string[]>
		local alias_groups = {}
		for _, path in ipairs(ambiguous_paths) do
			local alias = aliases[path]

			if not alias_groups[alias] then
				alias_groups[alias] = {}
			end

			alias_groups[alias][#alias_groups[alias] + 1] = path
		end

		---@type string[]
		local next_ambiguous_paths = {}

		for alias, group_paths in pairs(alias_groups) do
			if #group_paths == 1 then
				results[group_paths[1]] = alias
			else
				-- Still ambiguous, add to next iteration and climb up
				for _, path in ipairs(group_paths) do
					next_ambiguous_paths[#next_ambiguous_paths + 1] = path

					if path_to_level[path] < #path_parts[path] then
						path_to_level[path] = path_to_level[path] + 1
					end
				end
			end
		end

		ambiguous_paths = next_ambiguous_paths
	end

	return results
end

---@param base_bufs TabData[]
---@return TabData[]
local function cleanup_bufs(base_bufs)
	---@type string[]
	local base_file_names = {}

	for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
		for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
			local buf = vim.api.nvim_win_get_buf(win)

			local buf_name = vim.api.nvim_buf_get_name(buf)

			if vim.startswith(buf_name, "/") and vim.bo[buf].buftype == "" then
				local relative_buf_name = vim.fn.fnamemodify(buf_name, ":.")

				base_file_names[#base_file_names + 1] = relative_buf_name
			end
		end
	end

	if path_alias_cache.buf_list == nil or vim.deepcopy(base_file_names) ~= path_alias_cache.buf_list then
		path_alias_cache.buf_list = vim.deepcopy(base_file_names)
		path_alias_cache.aliases = calculate_unambiguous_paths(base_file_names)
	end

	local path_aliases = path_alias_cache.aliases or {}

	---@type TabData[]
	local processed_bufs = base_bufs

	for _, base in ipairs(processed_bufs) do
		if path_aliases[base.name] then
			base.name = path_aliases[base.name]
		end

		local buf_name = vim.api.nvim_buf_get_name(base.bufnr)
		if vim.wo[base.winnr].diff or vim.startswith(buf_name, "codediff") then
			base.name = " " .. base.name
		end

		if vim.bo[base.bufnr].modified then
			base.name = base.name .. " ●"
		end

		-- Embed padding
		base.name = " " .. base.name .. " "
	end

	return processed_bufs
end

local function render()
	local cur_tabpage = vim.api.nvim_get_current_tabpage()
	local cur_idx = vim.api.nvim_tabpage_get_number(cur_tabpage)

	---@type TabData[]
	local base_bufs = {}

	for i, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
		local winnr, bufnr = fetch_winnr_bufnr(tabpage)
		local base_name = fetch_buf_name(bufnr)

		base_bufs[#base_bufs + 1] = { name = base_name, page = i, bufnr = bufnr, winnr = winnr }
	end

	local processed_bufs = cleanup_bufs(base_bufs)
	local cur_tab_data = processed_bufs[cur_idx]
	local num_tabs = #processed_bufs
	local cols = vim.go.columns
	local is_init = cur_idx == 1
	local is_last = cur_idx == num_tabs
	local padding = (is_init or is_last) and LEN_PAD or 2 * LEN_PAD

	if len(cur_tab_data.name) + padding >= cols then
		local CUT = "…  "
		local LEN_CUT = len(CUT)

		local trunc = truncate_by_display_width(cur_tab_data.name, cols - padding - LEN_CUT)

		local line = ""

		if not is_init then
			line = line .. hl_more
		end

		line = line .. "%#TabLineSel#" .. trunc .. CUT

		if not is_last then
			line = line .. hl_more
		end

		return line
	else
		local content_len = 0

		---@type number
		local cur_mid

		for _, buf in ipairs(processed_bufs) do
			local buf_len = len(buf.name)

			if buf.page == cur_idx then
				cur_mid = (2 * content_len + buf_len) / 2
			end

			content_len = content_len + buf_len
		end

		if content_len <= cols then
			local line = ""

			for _, buf in ipairs(processed_bufs) do
				local hl = (buf.page == cur_idx and "TabLineSel" or "Tabline")

				line = line .. "%#" .. hl .. "#%" .. buf.page .. "T" .. buf.name .. "%T"
			end

			return line .. "%#TabLineFill#"
		end

		local cur_is_start = cur_mid < cols / 2
		local cur_is_end = content_len - cur_mid < cols / 2

		if cur_is_start or cur_is_end then
			local line = ""
			local actual_content_len = 0

			local loop_start = cur_is_start and 1 or num_tabs
			local loop_end = cur_is_start and num_tabs or 1
			local loop_step = cur_is_start and 1 or -1

			local space = cols - LEN_PAD

			for i = loop_start, loop_end, loop_step do
				local buf = processed_bufs[i]

				local buf_alias = buf.name

				if actual_content_len + len(buf.name) > space then
					local truncate_to_len = space - actual_content_len

					if truncate_to_len > 0 then
						if cur_is_start then
							buf_alias = truncate_by_display_width(buf_alias, truncate_to_len, false)
						else
							buf_alias = truncate_by_display_width(buf_alias, truncate_to_len, true)
						end

						local hl = (buf.page == cur_idx and "TabLineSel" or "Tabline")
						local this_tab = "%#" .. hl .. "#%" .. buf.page .. "T" .. buf_alias .. "%T"

						if cur_is_start then
							line = line .. this_tab
						else
							line = this_tab .. line
						end
					end

					break
				else
					actual_content_len = actual_content_len + len(buf_alias)

					local hl = (buf.page == cur_idx and "TabLineSel" or "Tabline")
					local this_tab = "%#" .. hl .. "#%" .. buf.page .. "T" .. buf_alias .. "%T"

					if cur_is_start then
						line = line .. this_tab
					else
						line = this_tab .. line
					end
				end
			end

			if cur_is_start then
				line = line .. hl_more
			else
				line = hl_more .. line
			end

			return line
		else
			local space_for_other_tabs = cols - len(cur_tab_data.name) - 2 * LEN_PAD

			local l_space = math.floor(space_for_other_tabs / 2)
			local r_space = math.ceil(space_for_other_tabs / 2)

			local r_line = ""
			local r_content_len = 0
			for i = cur_idx + 1, num_tabs do
				local buf = processed_bufs[i]
				local buf_alias = buf.name

				if r_content_len + len(buf_alias) > r_space then
					local truncate_to_len = r_space - r_content_len

					if truncate_to_len > 0 then
						buf_alias = truncate_by_display_width(buf_alias, truncate_to_len, false)

						r_line = r_line .. "%#Tabline#%" .. buf.page .. "T" .. buf_alias .. "%T"
					end

					break
				else
					r_content_len = r_content_len + len(buf_alias)

					r_line = r_line .. "%#Tabline#%" .. buf.page .. "T" .. buf_alias .. "%T"
				end
			end

			local l_line = ""
			local l_content_len = 0
			for i = cur_idx - 1, 1, -1 do
				local buf = processed_bufs[i]
				local buf_alias = buf.name

				if l_content_len + len(buf_alias) > l_space then
					local truncate_to_len = l_space - l_content_len

					if truncate_to_len > 0 then
						buf_alias = truncate_by_display_width(buf_alias, truncate_to_len, true)

						l_line = "%#Tabline#%" .. buf.page .. "T" .. buf_alias .. "%T" .. l_line
					end

					break
				else
					l_content_len = l_content_len + len(buf_alias)

					l_line = "%#Tabline#%" .. buf.page .. "T" .. buf_alias .. "%T" .. l_line
				end
			end

			local line = hl_more .. l_line

			line = line .. "%#TabLineSel#%" .. cur_tab_data.page .. "T" .. cur_tab_data.name .. "%T"

			return line .. r_line .. hl_more
		end
	end
end

_G.tabline = render
vim.go.tabline = "%{%v:lua.tabline()%}"
