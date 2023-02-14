local ok, lualine = pcall(require, "lualine")
if not ok or vim.g.started_by_firenvim then
	return nil
end

local no_format = require("utils.no_format")
local noice = require("noice.api.status")
local base09 = require("base16-colorscheme").colors.base09

local modified = "柳"

local noice_command = { noice.command.get, cond = noice.command.has, color = { fg = base09 } }

local noice_searchcount = { noice.search.get, cond = noice.search.has, color = { fg = base09 } }

local filetype_names = { TelescopePrompt = "Telescope", packer = "Packer" }

local filename =
	{ "filename", path = 1, symbols = { modified = modified, newfile = "", readonly = "", unnamed = "" } }

local macro_recording = {
	"macro-recording",
	fmt = function()
		local recording_register = vim.fn.reg_recording()
		if recording_register == "" then
			return ""
		else
			return "recording @" .. recording_register
		end
	end,
	color = { fg = "orange" },
}

lualine.setup({
	options = {
		disabled_filetypes = { statusline = no_format, winbar = {} },
		ignore_focus = {},
		always_divide_middle = true,
		refresh = { statusline = 1000, tabline = 1000, winbar = 1000 },
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = {
			filename,
			{ "diff", symbols = { added = "  ", modified = modified, removed = " " } },
			{ "diagnostics" },
		},
		lualine_c = {},
		lualine_x = { noice_searchcount, noice_command },
		lualine_y = { { "filetype", icon_only = true }, "progress", "location" },
		lualine_z = { "branch" },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { filename },
		lualine_x = { "location" },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {
		lualine_a = { { "buffers", filetype_names, show_filename_only = false } },
		lualine_b = { macro_recording },
		lualine_c = {},
		lualine_x = {},
		lualine_y = {},
		lualine_z = { "tabs" },
	},
	winbar = {},
	inactive_winbar = {},
	extensions = {
		"fugitive",
		"fzf",
		"man",
		"nvim-tree",
		"quickfix",
		"symbols-outline",
		"toggleterm",
	},
})
