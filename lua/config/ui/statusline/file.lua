local is_file = require("config.util").is_file
local Util = require("config.ui.statusline.util")

local function filetype_symbol()
	local ok, devicons = pcall(require, "nvim-web-devicons")
	if not ok then
		return ""
	end

	local ft = vim.bo.filetype
	local icon, iconhl = devicons.get_icon_color_by_filetype(ft, {
		default = true,
	})

	local hlname = ("%s%s"):format("Status", ft)

	Util.set_hl(hlname, {
		fg = iconhl,
		bg = Util.bg,
	})

	return Util.hl(hlname, true) .. icon
end

local function get_treesitter_status()
	local bufnr = vim.api.nvim_get_current_buf()

	local is_treesitter = vim.treesitter.highlighter.active[bufnr] ~= nil

	return is_treesitter and (Util.hl("StatusGreen", true) .. require("config.ui.icons").cmp.treesitter) or ""
end

local M = {}

function M.encoding()
	if not is_file() then
		return ""
	end

	local encoding = vim.bo.fileencoding and vim.bo.fileencoding or vim.o.encoding

	return encoding ~= "utf-8" and encoding or ""
end

function M.type(active)
	if not active or not is_file() then
		return ""
	end

	local filetype_items = {
		filetype_symbol(),
		get_treesitter_status(),
	}

	return table.concat(filetype_items, " ")
end

return M
