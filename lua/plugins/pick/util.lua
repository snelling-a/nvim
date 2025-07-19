local ok, pick = pcall(require, "mini.pick")
if not ok then
	return {}
end

---@param tbl table<string|number>
---@return table<string|number>
local function tbl_add_reverse_lookup(tbl)
	---@type table<string|number>
	local keys = {}
	---@diagnostic disable-next-line: no-unknown
	for k, _ in pairs(tbl) do
		table.insert(keys, k)
	end

	---@diagnostic disable-next-line: no-unknown
	for _, k in ipairs(keys) do
		local v = tbl[k]
		-- Check for conflicts
		if tbl[v] ~= nil then
			error(
				string.format(
					"The reverse lookup found an existing value for %q while processing key %q",
					tostring(v),
					tostring(k)
				)
			)
		end
		tbl[v] = k
	end
	return tbl
end

local function picker_remove_item(callback)
	local matches = pick.get_picker_matches()

	if not matches or matches.current == nil then
		return
	end

	if not callback(matches.current) then
		return
	end

	---@type {buffer:number,text:string}[]|nil
	local items = pick.get_picker_items()
	if not items then
		return
	end

	local updated_items = {}
	for index, item in ipairs(items) do
		if index ~= matches.current_ind then
			table.insert(updated_items, item)
		end
	end
	pick.set_picker_items(updated_items, { do_match = false })
end

local function bdelete()
	picker_remove_item(function(match)
		local okay = pcall(vim.api.nvim_buf_delete, match.bufnr, {})
		return okay
	end)
end

---@param str string
---@param len integer
---@return string
local function pad(str, len)
	local max_len = len - #str
	if #str >= len then
		str = str:sub(1, max_len - 3) .. "..."
	end

	return str .. string.rep(" ", max_len)
end

local extra = require("mini.extra")
pick.registry.autocmds = function()
	local autocmds = vim.api.nvim_get_autocmds({})
	table.sort(autocmds, function(a, b)
		return (a.group or math.huge) < (b.group or math.huge)
	end)

	local items = {}
	for _, autocmd in ipairs(autocmds) do
		if autocmd.event == "User" then
			autocmd.event = "User: " .. autocmd.pattern
		end

		local group = pad(tostring(autocmd.group), 4)
		local event = pad(autocmd.event or "Unknown", 30)
		local desc = pad(autocmd.desc or autocmd.command or "", 100)
		local group_name = pad(tostring(autocmd.group_name or ""), 30)

		local v = table.concat({ group, group_name, event, desc }, " " ..  --[[ Config.icons.fillchars.vert ]]"|" .. "")
		table.insert(items, v)
	end

	return pick.start({
		source = {
			name = "Autocmds",
			items = items,
		},
	})
end

pick.registry.files = function()
	local visits = require("mini.visits")
	local inf = math.huge

	local sort = visits.gen_sort.z()
	local visit_paths = visits.list_paths(nil, { sort = sort })
	---@type table<string|number>
	---@diagnostic disable-next-line: no-unknown
	visit_paths = vim.tbl_map(function(path)
		return vim.fn.fnamemodify(path, ":.")
	end, visit_paths)

	tbl_add_reverse_lookup(visit_paths)

	local current_file = vim.fn.expand("%:.")
	if visit_paths[current_file] then
		visit_paths[current_file] = inf
	end

	local show_with_icons = function(buf_id, items, query)
		return pick.default_show(buf_id, items, query, { show_icons = true })
	end
	local source = {
		---@param stritems string[]
		---@param inds number[]
		---@param query string[]
		---@return table
		match = function(stritems, inds, query)
			---@type number[]
			local filtered = pick.default_match(stritems, inds, query, { sync = true }) or {}
			table.sort(filtered, function(item1, item2)
				local path1 = stritems[item1]
				local path2 = stritems[item2]
				local score1 = visit_paths[path1] or inf
				local score2 = visit_paths[path2] or inf
				return score1 < score2
			end)

			return filtered
		end,
		name = "Files",
		show = show_with_icons,
	}
	return pick.builtin.cli({
		command = {
			"fd",
			"--type=f",
			"--color=never",
			"--no-follow",
			"--no-ignore-vcs",
			"--hidden",
			"--ignore-file=" .. vim.env.XDG_CONFIG_HOME .. "/fd/ignore",
		},
	}, { source = source })
end
pick.registry.buffers = function(local_opts, opts)
	return pick.builtin.buffers(
		local_opts,
		vim.tbl_deep_extend("force", opts or {}, {
			mappings = {
				delete = { char = "<C-d>", func = bdelete },
			},
		})
	)
end
pick.registry.colorschemes = function()
	local items = vim.fn.getcompletion("", "color")
	return pick.start({
		source = {
			items = items,
			preview = function(_, item)
				vim.cmd.colorscheme(item)
			end,
			choose = function(item)
				vim.cmd.colorscheme(item)
			end,
		},
	})
end
pick.registry.marks = function(local_opts, opts)
	local buffer = vim.api.nvim_get_current_buf()

	return extra.pickers.marks(
		local_opts,
		vim.tbl_deep_extend("force", opts or {}, {
			mappings = {
				delete = {
					char = "<C-d>",
					func = function()
						picker_remove_item(function(match)
							local mark = string.sub(match.text, 1, 1)
							return vim.api.nvim_buf_del_mark(buffer, mark) or vim.api.nvim_del_mark(mark)
						end)
					end,
				},
			},
		})
	)
end
pick.registry.registers = function(local_opts, opts)
	return extra.pickers.registers(
		local_opts,
		vim.tbl_deep_extend("force", opts or {}, {
			mappings = {
				delete = {
					char = "<C-d>",
					func = function()
						picker_remove_item(function(match)
							return vim.fn.setreg(match.text, "") == 0
						end)
					end,
				},
			},
		})
	)
end
pick.registry.resume = function()
	local can_resume, resume = pcall(pick.builtin.resume)

	if not can_resume then
		vim.notify("No previous pick session found")
		return
	end

	return resume
end
pick.registry.tabpages = function()
	local tabpages = vim.api.nvim_list_tabpages()

	return pick.start({
		source = {
			name = "Tabs",
			---@param tabpage number
			---@return table[]
			items = vim.tbl_map(function(tabpage)
				local tabpage_number = vim.api.nvim_tabpage_get_number(tabpage)
				local window = vim.api.nvim_tabpage_get_win(tabpage)
				local buffer = vim.api.nvim_win_get_buf(window)
				local name = vim.api.nvim_buf_get_name(buffer)
				return {
					text = string.format("%2d \0 %s", tabpage_number, name),
					bufnr = buffer,
					tabpage = tabpage,
				}
			end, tabpages),
			choose = function(item)
				if item ~= nil then
					vim.schedule(function()
						vim.api.nvim_set_current_tabpage(item.tabpage)
					end)
				end
			end,
		},
		mappings = {
			delete = { char = "<C-d>", func = bdelete },
		},
	})
end
