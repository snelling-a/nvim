local api = vim.api
local g = vim.g

local Util = {}

---wrapper around |nvim_create_augroup| with
---@param name string augroup name
---@param clear? boolean clear existing augroup default: true
---@return number 'augroup id'
function Util.augroup(name, clear) return api.nvim_create_augroup("User" .. name, { clear = clear or true }) end

---wrapper around |vim.tbl_extend| that always overwrites existing keys
---@param ... table two or more map-like tables
---@return table merged
function Util.tbl_extend_force(...) return vim.tbl_extend("force", ...) end

---@param custom_options table|nil Table of |:map-arguments|
---@return table '|:map-arguments|'
local function get_map_options(custom_options)
	local default_options = { silent = true, noremap = true }

	if custom_options then
		default_options = Util.tbl_extend_force(default_options, custom_options or {})
	end

	return default_options
end
---@alias VimMode "c"|"i"|"n"|"o"|"t"|"v"|"x"

---@param mode VimMode|table<VimMode> Mode short-name, see |nvim_set_keymap()|.
--- Can also be list of modes to create mapping on multiple modes.
---@param lhs string Left-hand side |{lhs}| of the mapping.
---@param rhs string|function Right-hand side |{rhs}| of the mapping, can be a Lua function.
---@param opts table|nil Table of |:map-arguments|.
function Util.map(mode, lhs, rhs, opts) vim.keymap.set(mode, lhs, rhs, get_map_options(opts)) end

for _, mode in ipairs({ "c", "i", "n", "o", "t", "v", "x" }) do
	Util[mode .. "map"] = function(...) Util.map(mode, ...) end
end

---Wrapper around Util.nmap using the <leader> in lhs
---@param lhs string Left-hand side |{lhs}| of the mapping
---@param rhs string|function Right-hand side |{rhs}| of the mapping, can be a Lua function
---@param opts? table Table of |:map-arguments|
---@param mode? VimMode|table<VimMode> Mode short-name, see |nvim_set_keymap()|.
--- Can also be list of modes to create mapping on multiple modes.
function Util.mapL(lhs, rhs, opts, mode) Util.map(mode or "n", "<leader>" .. lhs, rhs, opts) end

---Check if plugin is available
---@param plugin string name of plugin
---@return boolean boolean if plugin is loaded
function Util.has(plugin) return package.loaded[plugin] and true end

---wrapper for |nvim_feedkeys| that handles <key> syntax
---@param keys string
---@param mode? VimMode
---@param escape_ks? boolean default: true
function Util.feedkeys(keys, mode, escape_ks)
	if keys:sub(1, 1) == "<" then
		keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
		escape_ks = false
	end

	if escape_ks == nil then
		escape_ks = true
	end

	return api.nvim_feedkeys(keys, mode or "n", escape_ks)
end

---Wrapper for |zz| (to scroll center) and |zv| (to open fold) keymaps
function Util.scroll_center()
	Util.feedkeys("zz")

	Util.feedkeys("zv")
end

---check if the current editor is terminal vim
---@return boolean
function Util.is_vim()
	if g.started_by_firenvim or g.vscode then
		return false
	else
		return true
	end
end

---returns `true` if current buffer should be formatted or not
---@return boolean 'should file have formatting'
function Util.is_file() return not vim.tbl_contains(require("config.util.constants").no_format, vim.bo.filetype) end

---returns `!filetype[]` for each filetype in `no_format`
Util.no_format = vim.tbl_map(function(filetype) return "!" .. filetype end, require("config.util.constants").no_format)

function Util.is_buf_big(bufnr)
	local max_filesize = 100 * 1024 -- 100 KB
	local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
	if ok and stats and stats.size > max_filesize then
		return true
	else
		return false
	end
end

---wrapper around  icon so prompts are consistant
---@param icon string
---@return string ' + icon'
function Util.get_prompt(icon) return string.format("%s %s ", icon, require("config.ui.icons").misc.right) end

---@param icon string
---@return string 'icon + " "'
function Util.pad_right(icon) return string.format("%s ", icon) end

return Util
