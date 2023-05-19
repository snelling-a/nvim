local no_format = require("config.util.constants").no_format

local function no_color()
	return vim.tbl_map(function(filetype) return "!" .. filetype end, no_format)
end

local M = { "NvChad/nvim-colorizer.lua" }

M.opts = {
	buftypes = no_color(),
	filetypes = { "*", cmp_docs = { always_update = true } },
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
		sass = { enable = false, parsers = { "css" } },
		tailwind = false,
		virtualtext = require("config.ui.icons").misc.square,
	},
}

return M
