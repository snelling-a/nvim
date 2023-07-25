local CarbonNow = { "ellisonleao/carbon-now.nvim" }

CarbonNow.lazy = true

CarbonNow.cmd = "CarbonNow"

CarbonNow.opts = {
	open_cmd = "open",
	options = {
		font_family = "Fira Code",
		line_numbers = true,
		theme = "base16-dark",
		titlebar = "",
	},
}

return CarbonNow
