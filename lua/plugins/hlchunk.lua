local get_hl = require("config.ui.util").get_hl

local function get_exclude_filetypes()
	local ft = {}

	for _, v in pairs(require("config.util.constants").no_format) do
		ft[v] = true
	end

	return ft
end

local M = {
	"shellRaining/hlchunk.nvim",
}

M.cond = require("config.util").is_vim()

M.event = require("config.util.constants").lazy_event

function M.opts()
	local orange = get_hl("IncSearch", "bg")
	local red = get_hl("DiagnosticError")

	return {
		blank = {
			enable = false,
		},
		chunk = {
			chars = {
				right_arrow = "⇀",
			},
			exclude_filetypes = get_exclude_filetypes(),
			max_file_size = 1024 * 1024,
			notify = false,
			style = {
				{
					fg = orange,
				},
				{
					fg = red,
				},
			},
			textobject = "ac",
		},
		context = {
			enable = false,
		},
		indent = {
			enable = false,
		},
		line_num = {
			style = orange,
		},
	}
end

return M
