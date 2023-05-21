local M = { "freddiehaddad/feline.nvim" }

M.cond = require("config.util").is_vim()

M.dependencies = { "SmiteshP/nvim-navic" }

function M.config()
	local statusbar = require("config.ui.statusline")
	local winbar = require("config.ui.winbar")
	local feline = require("feline")

	feline.setup({
		components = statusbar.components,
		force_inactive = { filetypes = require("config.util.constants").no_format },
		theme = statusbar.theme,
		vi_mode_colors = statusbar.vi_mode_colors,
	})

	feline.winbar.setup({ components = winbar.components })
end

return M
