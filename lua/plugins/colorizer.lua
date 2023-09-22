--- @type LazySpec
local M = {
	"NvChad/nvim-colorizer.lua",
}

M.event = {
	"BufAdd",
}

M.opts = {
	buftypes = require("config.util").no_format,
	filetypes = {
		"*",
		cmp_docs = {
			always_update = true,
		},
	},
	user_default_options = {
		AARRGGBB = true,
		always_update = false,
		css = false,
		css_fn = false,
		hsl_fn = false,
		mode = "foreground",
		names = true,
		RGB = true,
		rgb_fn = false,
		RRGGBB = true,
		RRGGBBAA = true,
		sass = {
			enable = false,
			parsers = {
				"css",
			},
		},
		tailwind = false,
		virtualtext = require("config.ui.icons").misc.square,
	},
}

return M
