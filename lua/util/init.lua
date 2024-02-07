--- Fast implementation to check if a table is a list
---@param tbl table
local function is_list(tbl)
	local i = 0
	for _ in pairs(tbl) do
		i = i + 1
		if tbl[i] == nil then
			return false
		end
	end
	return true
end

local function can_merge(v)
	return type(v) == "table" and (vim.tbl_isempty(v) or not is_list(v))
end

---@class Util
local M = {}

setmetatable(M, {
	__index = function(self, field)
		self[field] = require(("util.%s"):format(field))
		return self[field]
	end,
})

---@return boolean are_buffers_listed `true` if there are buffers listed
function M.are_buffers_listed()
	return #vim.fn.getbufinfo({ buflisted = 1 }) > 0
end

---@return boolean are_loc_items `true` if there are buffers in the loclist
function M.are_loc_items()
	local win_id = vim.api.nvim_get_current_win()
	local nr_items = #vim.fn.getloclist(win_id)
	if nr_items < 1 then
		M.logger:error("Location list is empty", "776")
		return false
	end

	return true
end

---@return boolean are_qf_items `true` if there are items in the quickfix list
function M.are_qf_items()
	local nr_items = #vim.fn.getqflist()
	if nr_items < 1 then
		M.logger:error("Quickfix list is empty", "42")
		return false
	end

	return true
end

---@param str string
---@return string Str
function M.capitalize_first_letter(str)
	str = str:gsub("^%l", string.upper)

	return str
end

--- name the `ftdetect/*.lua` file the target filetype
---@param pattern string|table<string> pattern for the autocmd
---@param filetype string
function M.ftdetect(pattern, filetype)
	pattern = M.table_or_string(pattern)

	vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
		callback = function()
			vim.bo.filetype = filetype
		end,
		desc = ("Set filetype for %s files"):format(filetype),
		group = require("autocmd").augroup(("FTDetect%sFiletype"):format(M.capitalize_first_letter(filetype))),
		pattern = pattern,
	})
end

--- wrapper for `nvim_get_option_value` with `scope = "local"`
---@param name string
function M.get_opt_local(name)
	return vim.api.nvim_get_option_value(name, { scope = "local" })
end

--- get the correct separator based on OS
---@return string separator
function M.get_separator()
	if jit then
		local os = string.lower(jit.os)
		if os == "linux" or os == "osx" or os == "bsd" then
			return "/"
		else
			return "\\"
		end
	else
		return string.sub(package.config, 1, 1)
	end
end

--- wrapper around  icon so prompts are consistent
---@param icon string
---@return string --  + icon
function M.get_prompt(icon)
	return ("%s %s "):format(icon, require("ui.icons").misc.right)
end

---@param func function
---@param name string
---@return any
function M.get_upvalue(func, name)
	local i = 1
	while true do
		local n, v = debug.getupvalue(func, i)
		if not n then
			break
		end
		if n == name then
			return v
		end
		i = i + 1
	end
end

---@param bufnr integer
---@return boolean buf_is_big `true `if buffer is bigger than 100kb
function M.is_buf_big(bufnr)
	local max_filesize = 100 * 102
	local ok, stat = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
	if ok and stat and stat.size > max_filesize then
		M.logger:warn("File is big\nsome functionality may be disabled")
		return true
	else
		return false
	end
end

---@return boolean is_file `true` if current buffer is a normal file
function M.is_file()
	return not vim.tbl_contains(require("util.constants").no_format, vim.bo.filetype)
end

---@param win integer?
---@return boolean is_loc_list `true` if current window or `win` is the location list
function M.is_loc_list(win)
	local win_getid = vim.fn.win_getid
	win = win and win_getid(win) or win_getid()

	return vim.fn.getwininfo(win)[1]["loclist"] == 1
end

---@return boolean is_man `true` if Man page is open
function M.is_man()
	for _, buf in pairs(vim.fn.getbufinfo() or {}) do
		if buf.name:find("man://") then
			return true
		end
	end

	return false
end

---@return boolean is_modifiable `true` if the current buffer is modifiable
function M.is_modifiable()
	if M.get_opt_local("modifiable") then
		return true
	end

	M.logger:error("Cannot make changes, 'modifiable' is off", "21")

	return false
end

---@return boolean is_vim `true` if the current editor is terminal vim
function M.is_vim()
	local g = vim.g

	if g.started_by_firenvim or g.vscode then
		return false
	else
		return true
	end
end

---@return boolean is_windows `true` if on Windows
function M.is_windows()
	return vim.uv.os_uname().sysname:find("Windows") ~= nil
end

M.logger = require("util.logger"):new("Util")

--- Merges the values similar to vim.tbl_deep_extend with the **force** behavior,
--- but the values can be any type, in which case they override the values on the left.
--- Values will me merged in-place in the first left-most table. If you want the result to be in
--- a new table, then simply pass an empty table as the first argument `vim.merge({}, ...)`
--- Supports clearing values by setting a key to `vim.NIL`
---@generic T
---@param ... T
---@return T
function M.merge(...)
	local ret = select(1, ...)
	if ret == vim.NIL then
		ret = nil
	end
	for i = 2, select("#", ...) do
		local value = select(i, ...)
		if can_merge(ret) and can_merge(value) then
			for k, v in pairs(value) do
				ret[k] = M.merge(ret[k], v)
			end
		elseif value == vim.NIL then
			ret = nil
		elseif value ~= nil then
			ret = value
		end
	end
	return ret
end

--- Convert string arguments to `table[1]`
--- Typecheck for nil values when table is needed
---@param args string|table|nil
---@return table
function M.table_or_string(args)
	if type(args) == "string" then
		return {
			args,
		}
	elseif type(args) == "nil" then
		return {}
	end

	return args
end

--- wrapper around |vim.tbl_extend| that always overwrites existing keys
---@vararg  table two or more map-like tables
---@return table merged
function M.tbl_extend_force(...)
	return vim.tbl_extend("force", ...)
end

---@param opts? string|{msg:string, on_error:fun(msg)}
function M.try(fn, opts)
	opts = type(opts) == "string" and {
		msg = opts,
	} or opts or {}
	local msg = opts.msg
	-- error handler
	local error_handler = function(err)
		msg = ("%s%s"):format(msg or "", err)
		if opts.on_error then
			opts.on_error(msg)
		else
			vim.schedule(function()
				M.logger:error(msg)
			end)
		end
		return err
	end

	---@type boolean, any
	local ok, result = xpcall(fn, error_handler)
	return ok and result or nil
end

return M
