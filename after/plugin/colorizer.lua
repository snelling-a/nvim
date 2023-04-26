local no_format = require("utils.no_format")

local function no_color()
	return vim.tbl_map(function(filetype) return "!" .. filetype end, no_format)
end

require("colorizer").setup({
	filetypes = { "*", cmp_docs = { always_update = true } },
	user_default_options = {
		RGB = true,
		RRGGBB = true,
		names = true,
		RRGGBBAA = true,
		AARRGGBB = true,
		rgb_fn = false,
		hsl_fn = false,
		css = false,
		css_fn = false,
		mode = "foreground",
		tailwind = false,
		sass = { enable = false, parsers = { "css" } },
		virtualtext = "■",
		always_update = false,
	},
	buftypes = no_color(),
})
