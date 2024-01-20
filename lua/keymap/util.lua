---@class keymap.util
---@field cmap map
---@field imap map
---@field nmap map
---@field omap map
---@field smap map
---@field tmap map
---@field vmap map
---@field xmap map
local M = {}

M.Logger = require("util.logger"):new("Keymaps")

---@param custom_options table|nil Table of |:map-arguments|
---@return table -- |:map-arguments|
local function get_map_options(custom_options)
	local default_options = {
		silent = true,
		noremap = true,
	}

	if custom_options then
		default_options = require("util").tbl_extend_force(default_options, custom_options or {})
	end

	return default_options
end

--- wrapper for |nvim_feedkeys| that handles <key> syntax
---@param keys string
---@param mode? VimMode
---@param escape_ks? boolean default: true
function M.feedkeys(keys, mode, escape_ks)
	local api = vim.api

	if keys:sub(1, 1) == "<" then
		keys = api.nvim_replace_termcodes(keys, true, false, true)
		escape_ks = false
	end

	if escape_ks == nil then
		escape_ks = true
	end

	return api.nvim_feedkeys(keys, mode or "n" --[[@as ModeString]], escape_ks)
end

---@param mode VimMode
---@param lhs string Left-hand side |{lhs}| of the mapping.
---@param rhs string|function Right-hand side |{rhs}| of the mapping, can be a Lua function.
---@param opts table? Table of |:map-arguments|.
function M.map(mode, lhs, rhs, opts)
	vim.keymap.set(mode, lhs, rhs, get_map_options(opts))
end

for _, mode in ipairs({
	"c",
	"i",
	"n",
	"o",
	"s",
	"t",
	"v",
	"x",
}) do
	M[("%smap"):format(mode)] = function(...)
		M.map(mode, ...)
	end
end

return M
