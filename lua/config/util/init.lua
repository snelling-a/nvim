local api = vim.api
local g = vim.g

---@alias KeyMapMode "c"|"i"|"n"|"o"|"t"|"v"|"x"
local key_map_modes = { "c", "i", "n", "o", "t", "v", "x" }

---wrapper for nvim_feedkeys that handles <key> syntax
---@param keys string
---@param mode? KeyMapMode default: "n"
---@param escape_ks? boolean default: false
local function feedkeys(keys, mode, escape_ks)
	if keys:sub(1, 1) == "<" then
		keys = vim.api.nvim_replace_termcodes(keys, true, false, true)
	end

	return api.nvim_feedkeys(keys, mode or "n", escape_ks or false)
end

---@class MapOptions
---@field silent? boolean
---@field noremap? boolean
---@field desc? string
---@field callback? function
---@field replace_keycodes? boolean

local Util = {}

---wrapper around nvim_create_augroup with
---@param name string augroup name
---@param clear? boolean clear existing augroup default: true
---@return number 'augroup id'
function Util.augroup(name, clear) return api.nvim_create_augroup("User" .. name, { clear = clear or true }) end

---wrapper around vim.tbl_extend that always overwrites existing keys
---@param ... table two or more map-like tables
---@return table merged
function Util.tbl_extend_force(...) return vim.tbl_extend("force", ...) end

---comment
---@param custom_options MapOptions
---@return MapOptions
local function get_map_options(custom_options)
	local options = { silent = true, noremap = true }
	if custom_options then
		options = Util.tbl_extend_force(options, custom_options or {})
	end
	return options
end

---@class KeyMapArgs
---@field mode string|table
---@field target string
---@field source string|function
---@field opts? MapOptions

---create a keymap
---@param mode string|table
---@param target string
---@param source string|function
---@param opts? MapOptions
function Util.map(mode, target, source, opts) vim.keymap.set(mode, target, source, opts and get_map_options(opts)) end

for _, mode in ipairs(key_map_modes) do
	Util[mode .. "map"] = function(...) Util.map(mode, ...) end
end

---Check if plugin is available
---@param plugin string name of plugin
---@return boolean boolean if plugin is loaded
function Util.has(plugin) return package.loaded[plugin] and true end

function Util.scroll_center() feedkeys("zz") end

Util.feedkeys = feedkeys

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
