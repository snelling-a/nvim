---@type LazySpec
local M = { "NvChad/nvim-colorizer.lua" }

M.event = require("util").constants.lazy_event

M.opts = {
	user_default_options = {
		AARRGGBB = true,
		mode = "foreground",
		names = false,
		virtualtext = require("ui.icons").misc.square,
	},
}

return M
