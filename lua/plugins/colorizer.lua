---@type LazySpec
local M = { "NvChad/nvim-colorizer.lua" }


M.opts = {
	user_default_options = {
		AARRGGBB = true,
		mode = "foreground",
		names = false,
		virtualtext = require("ui.icons").misc.square,
	},
}

return M
