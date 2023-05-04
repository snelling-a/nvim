local icons = require("config.ui.icons")
local navic = require("nvim-navic")

navic.setup({
	highlight = true,
	lsp = { auto_attach = true, preference = { "tsserver", "graphql", "vtsls" } },
})

local navic_component = {
	provider = function() return navic.get_location() end,
	enabled = function() return navic.is_available() end,
}

local file_info = {
	provider = {
		left_sep = "block",
		name = "file_info",
		opts = { file_readonly_icon = icons.file.readonly, type = "relative-short" },
		right_sep = "block",
	},
}
local file_info_inactive = {
	provider = {
		hl = { bg = "black" },
		left_sep = "block",
		name = "file_info",
		opts = { type = "relative", file_readonly_icon = icons.file.readonly },
	},
}

local active = { { file_info, { provider = " " }, navic_component }, {}, {} }

local inactive = { { file_info_inactive }, {} }

local Winbar = {}

Winbar.components = { active = active, inactive = inactive }

return Winbar
