local no_format = require("config.util.constants").no_format

local M = {}

--- returns `!filetype[]` for each filetype in `no_format`
M.no_format = vim.tbl_map(function(filetype) return "!" .. filetype end, no_format)

--- wrapper around |nvim_create_augroup| with
--- @param name string augroup name
--- @param clear? boolean clear existing augroup default: true
--- @return number 'augroup id'
function M.augroup(name, clear)
	return vim.api.nvim_create_augroup("User" .. name, {
		clear = clear or true,
	})
end

function M.capitalize_first_letter(str) return str:gsub("^%l", string.upper) end

--- wrapper for |nvim_feedkeys| that handles <key> syntax
--- @param keys string
--- @param mode? VimMode
--- @param escape_ks? boolean default: true
function M.feedkeys(keys, mode, escape_ks)
	local api = vim.api

	if keys:sub(1, 1) == "<" then
		keys = api.nvim_replace_termcodes(keys, true, false, true)
		escape_ks = false
	end

	if escape_ks == nil then
		escape_ks = true
	end

	return api.nvim_feedkeys(keys, mode or "n", escape_ks)
end

--- name the `ftdetect/*.lua` file the target filetype
--- @param pattern string|table<string> pattern for the autocmd
--- @param filetype string
function M.ftdetect(pattern, filetype)
	pattern = type(pattern) == "table" and pattern or {
		pattern,
	}

	vim.api.nvim_create_autocmd({
		"BufNewFile",
		"BufRead",
	}, {
		callback = function() vim.bo.filetype = filetype end,
		desc = "Set filetype for " .. filetype .. " files",
		group = M.augroup("FTDetect" .. M.capitalize_first_letter(filetype) .. "Filetype"),
		pattern = pattern,
	})
end

--- @param custom_options table|nil Table of |:map-arguments|
--- @return table -- |:map-arguments|
local function get_map_options(custom_options)
	local default_options = {
		silent = true,
		noremap = true,
	}

	if custom_options then
		default_options = M.tbl_extend_force(default_options, custom_options or {})
	end

	return default_options
end

--- wrapper for `nvim_get_option_value` with `scope = "local"`
--- @param name string
function M.get_opt_local(name)
	return vim.api.nvim_get_option_value(name, {
		scope = "local",
	})
end

--- wrapper around  icon so prompts are consistant
--- @param icon string
--- @return string --  + icon
function M.get_prompt(icon) return string.format("%s %s ", icon, require("config.ui.icons").misc.right) end

--- Check if plugin is available
--- @param plugin string name of plugin
--- @return boolean boolean if plugin is loaded
function M.has(plugin) return package.loaded[plugin] and true end

function M.is_buf_big(bufnr)
	local max_filesize = 100 * 1024 -- 100 KB
	local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(bufnr))
	if ok and stats and stats.size > max_filesize then
		return true
	else
		return false
	end
end

--- returns `true` if current buffer should be formatted or not
--- @return boolean -- should file have formatting
function M.is_file() return not vim.tbl_contains(no_format, vim.bo.filetype) end

--- check if the current editor is terminal vim
--- @return boolean
function M.is_vim()
	local g = vim.g

	if g.started_by_firenvim or g.vscode then
		return false
	else
		return true
	end
end

--- @param mode VimMode|table<VimMode> Mode short-name, see |nvim_set_keymap()|.
--- Can also be list of modes to create mapping on multiple modes.
--- @param lhs string Left-hand side |{lhs}| of the mapping.
--- @param rhs string|function Right-hand side |{rhs}| of the mapping, can be a Lua function.
--- @param opts table|nil Table of |:map-arguments|.
function M.map(mode, lhs, rhs, opts) vim.keymap.set(mode, lhs, rhs, get_map_options(opts)) end

for _, mode in ipairs({
	"c",
	"i",
	"n",
	"o",
	"t",
	"v",
	"x",
}) do
	M[mode .. "map"] = function(...) M.map(mode, ...) end
end

--- Wrapper around Util.nmap using the <leader> in lhs
--- @param lhs string Left-hand side |{lhs}| of the mapping
--- @param rhs string|function Right-hand side |{rhs}| of the mapping, can be a Lua function
--- @param opts? table Table of |:map-arguments|
--- @param mode? VimMode|table<VimMode> Mode short-name, see |nvim_set_keymap()|.
--- Can also be list of modes to create mapping on multiple modes.
function M.mapL(lhs, rhs, opts, mode) M.map(mode or "n", "<leader>" .. lhs, rhs, opts) end

--- Wrapper for |zz| (to scroll center) and |zv| (to open fold) keymaps
function M.scroll_center()
	M.feedkeys("zz")
	M.feedkeys("zv")
end

--- Convert string arguments to `table[1]`
--- Typecheck for nil values when table is needed
--- @param args string|table|nil
--- @return table
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
--- @param ... table two or more map-like tables
--- @return table merged
function M.tbl_extend_force(...) return vim.tbl_extend("force", ...) end

return M
