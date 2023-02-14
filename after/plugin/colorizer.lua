local no_format = require("utils.no_format")
local utils = require("utils")

local function no_color()
	return vim.tbl_map(function(filetype) return "!" .. filetype end, no_format)
end

require("colorizer").setup(utils.tbl_extend_force({
	["*"] = {
		RGB = true,
		RRGGBB = true,
		names = true,
		RRGGBBAA = true,
		rgb_fn = true,
		hsl_fn = true,
		css = true,
		css_fn = true,
	},
}, no_color()))
