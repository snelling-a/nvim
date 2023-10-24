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
end

return M
