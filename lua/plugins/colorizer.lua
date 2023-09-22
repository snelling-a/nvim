--- @type LazySpec
local M = {
	"NvChad/nvim-colorizer.lua",
}

M.event = require("config.util.constants").lazy_event

M.opts = {
	buftypes = require("config.util").no_format,
	user_default_options = {
		AARRGGBB = true,
		mode = "foreground",
		names = false,
		virtualtext = require("config.ui.icons").misc.square,
	},
}

return M
