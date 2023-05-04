local M = { "freddiehaddad/feline.nvim" }

M.cond = require("config.util").is_vim()

M.dependencies = { "SmiteshP/nvim-navic" }

function M.config()
	local statusbar = require("config.ui.statusbar")
	local winbar = require("config.ui.winbar")
	local feline = require("feline")

	---@diagnostic disable-next-line: need-check-nil
	feline.setup({
		components = statusbar.components,
		theme = statusbar.theme,
		vi_mode_colors = statusbar.vi_mode_colors,
	})

	---@diagnostic disable-next-line: need-check-nil
	feline.winbar.setup({ components = winbar.components })
end

return M
