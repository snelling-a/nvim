if not require("utils").is_vim() then
	return nil
end

local navic_ok, navic = pcall(require, "nvim-navic")
local feline_ok, feline = pcall(require, "feline")

local icons = require("ui.icons")

if not navic_ok or not feline_ok then
	return nil
end

navic.setup({ lsp = { auto_attach = true, preference = { "tsserver", "graphql" } }, highlight = true })

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

feline.winbar.setup({
	components = {
		active = { { file_info, { provider = " " }, navic_component }, {}, {} },
		inactive = { { file_info_inactive }, {} },
	},
})
