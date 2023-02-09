local ok, lualine = pcall(require, "lualine")
if not ok or vim.g.started_by_firenvim then
	return nil
end

local base09 = "#dc9656"

local modified = "柳"

local noice_command = {
	require("noice").api.status.command.get,
	cond = require("noice").api.status.command.has,
	color = { fg = base09 },
}

local noice_searchcount = {
	require("noice").api.status.search.get,
	cond = require("noice").api.status.search.has,
	color = { fg = base09 },
}

local filetype_names = {
	TelescopePrompt = "Telescope",
	packer = "Packer",
}

local filename = {
	"filename",
	path = 1,
	symbols = {
		modified = modified,
		newfile = "",
		readonly = "",
		unnamed = "",
	},
}

lualine.setup({
	options = {
		disabled_filetypes = {
			statusline = { "DiffviewFiles", "NvimTree", "packer", "undotree" },
			winbar = {},
		},
		ignore_focus = {},
		always_divide_middle = true,
		refresh = {
			statusline = 1000,
			tabline = 1000,
			winbar = 1000,
		},
	},
	sections = {
		lualine_a = {
			"mode",
		},
		lualine_b = {
			filename,
			{ "diff", symbols = { added = "  ", modified = modified, removed = " " } },
			{ "diagnostics" },
		},
		lualine_x = {
			noice_searchcount,
			noice_command,
		},
		lualine_y = {
			{
				"filetype",
				icon_only = true,
			},
			"progress",
			"location",
		},
		lualine_c = {},
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
		lualine_a = {
			{ "buffers", filetype_names },
		},
		lualine_b = {
			{
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
			},
		},
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
