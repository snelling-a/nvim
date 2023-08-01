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
		background_image = nil,
		background_imageSelection = nil,
		background_mode = "image",
	},
}

return CarbonNow
