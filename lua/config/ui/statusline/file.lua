local Icons = require("config.ui.icons")
local Statusline = require("config.ui.statusline")
local api = vim.api
local bo = vim.bo

--- @param active 0|1
--- @return string
local function filetype_symbol(active)
	local ok, devicons = pcall(require, "nvim-web-devicons")
	if not ok then
		return ""
	end

	local name = api.nvim_buf_get_name(0)
	local icon, iconhl = devicons.get_icon_color(name, bo.filetype, { default = true })

	local hlname = iconhl:gsub("#", "Status")
	api.nvim_set_hl(0, hlname, { fg = iconhl, bg = Statusline.bg })

	return Statusline.hl(hlname, active) .. icon
end

local function get_treesitter_status(active)
	local bufnr = api.nvim_get_current_buf()

	local is_treesitter = vim.treesitter.highlighter.active[bufnr] ~= nil

	return is_treesitter and (Statusline.hl("StatusTS", active) .. Icons.cmp.treesitter) or ""
end

local M = {}

function M.type(active)
	local filetype_items = {
		filetype_symbol(active),
		get_treesitter_status(active), }

	return table.concat(filetype_items, " ")
end

function M.encoding()
	local encoding = vim.bo.fileencoding and vim.bo.fileencoding or vim.o.encoding

	return encoding ~= "utf-8" and encoding or ""
end

return M
