local Icons = require("config.ui.icons")

--- @param win integer
local function extract_filename(win)
	local bufnr = vim.api.nvim_win_get_buf(win)
	local fullname = vim.api.nvim_buf_get_name(bufnr)

	if fullname ~= "" then
		local shortname = vim.fn.fnamemodify(fullname, ":~:.:gs%(.?[^/])[^/]*/%\1/%")
		if #shortname > 30 then
			shortname = vim.fn.fnamemodify(fullname, ":t")
		end

		local is_modified = vim.api.nvim_get_option_value("modified", {
			buf = bufnr,
		})
		local mod = is_modified and Icons.file.modified or ""

		return ("%s %s"):format(mod, shortname)
	end
end

--- @param tabpage integer
--- @param window integer
local function get_best_window_filename(tabpage, window)
	local filename = extract_filename(window)

	if filename == nil then
		local wins = vim.api.nvim_tabpage_list_wins(tabpage)
		if #wins > 1 then
			for _, win in ipairs(wins) do
				filename = extract_filename(win)
				break
			end
		end
	end

	if filename == nil then
		return ("[ %s ]"):format(Icons.file.unnamed)
	end

	return filename
end

--- @param win integer
local function is_float_win(win)
	local config = vim.api.nvim_win_get_config(win)
	return config.zindex and config.zindex > 0
end

--- @param tabpage integer
local function get_name(tabpage)
	local title = vim.t[tabpage].tab_title

	if title ~= nil then
		return title
	end

	local window = vim.api.nvim_tabpage_get_win(tabpage)

	if is_float_win(window) then
		return vim.t[tabpage].last_buffer_filename
	end

	local filename = get_best_window_filename(tabpage, window)

	vim.t[tabpage].last_buffer_filename = filename

	return filename
end

function _G.Tabline()
	local tabline = {}
	local current = vim.api.nvim_get_current_tabpage()

	for i, tabpage in ipairs(vim.api.nvim_list_tabpages()) do
		local hi = tabpage == current and "%#TabLineSel#" or "%#TabLine#"

		table.insert(tabline, ("%%%dT"):format(i)) -- mouse click target region
		table.insert(tabline, ("%s %s "):format(hi, get_name(tabpage)))
	end

	table.insert(tabline, "%T") -- end mouse click region(s).
	table.insert(tabline, "%#TabLineFill#")

	return table.concat(tabline, "")
end

vim.opt.tabline = [[%!v:lua.Tabline()]]
