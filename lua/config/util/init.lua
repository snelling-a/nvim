local logger = require("config.util.logger")
local no_format = require("config.util.no_format")

local api = vim.api
local fn = vim.fn
local cmd = vim.cmd
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

function Util.reload_modules()
	local config_path = fn.stdpath("config")
	local lua_files = fn.glob(config_path .. "/**/*.lua", false, true)

	for _, file in ipairs(lua_files) do
		local module_name = string.gsub(file, ".*/(.*)/(.*).lua", "%1.%2")

		package.loaded[module_name] = nil
	end

	cmd.source("$MYVIMRC")

	logger.info({ msg = "Reloaded all config modules\nReloaded lua modules", title = "Happy hacking!" })
end

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
---@param filetype string result of `vim.bo.filetype`
---@return _ boolean if `filetype` should have formatting
function Util.should_have_formatting(filetype) return not vim.tbl_contains(no_format, filetype) end

local vault_directory = os.getenv("NOTES") or os.getenv("HOME") .. "/notes"

Util.obsidian = { vault_directory = vault_directory, is_vault_directory = vim.fn.getcwd() == vault_directory }

return Util
