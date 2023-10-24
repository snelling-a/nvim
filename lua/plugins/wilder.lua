--- @type LazySpec
local M = {
	"gelguy/wilder.nvim",
}

M.event = {
	"CmdlineEnter",
}

function M.config()
	local wilder = require("wilder")
	wilder.setup({
		modes = {
			":",
			"/",
		},
	})

	wilder.set_option("use_python_remote_plugin", 0)

	wilder.set_option("pipeline", {
		wilder.branch(
			wilder.substitute_pipeline({
				pipeline = wilder.vim_search_pipeline({
					hide_in_replace = true,
				}),
			}),
			wilder.cmdline_pipeline({
				fuzzy = 2,
				hide_in_substitute = false,
				language = "vim",
			}),
			wilder.vim_search_pipeline(),
			{
				wilder.history(0),
				wilder.result({
					draw = {
						function() return "🤷" end,
					},
				}),
			}
		),
	})

	local gradient_colors = {
		vim.g.base16_08,
		vim.g.base16_09,
		vim.g.base16_0A,
		vim.g.base16_0B,
		vim.g.base16_0C,
		vim.g.base16_0D,
		vim.g.base16_0E,
		vim.g.base16_0F,
	}

	local gradient = {}
	for i, fg in ipairs(gradient_colors) do
		gradient[i] = wilder.make_hl("WilderGradient" .. i, "Pmenu", {
			{
				a = 1,
			},
			{
				a = 1,
			},
			{
				foreground = fg,
			},
		})
	end

	wilder.set_option(
		"renderer",
		wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
			highlights = {
				default = "Pmenu",
				border = "PmenuBorder",
				gradient = gradient,
			},
			border = "rounded",
			highlighter = wilder.highlighter_with_gradient({
				wilder.vim_basic_highlighter(),
			}),
			left = {
				" ",
				wilder.popupmenu_devicons(),
			},
			right = {
				" ",
				wilder.popupmenu_scrollbar(),
			},
			empty_message = wilder.popupmenu_empty_message_with_spinner({
				done = "🤷",
			}),
		}))
	)
end

return M
