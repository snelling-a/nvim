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
end

return M
