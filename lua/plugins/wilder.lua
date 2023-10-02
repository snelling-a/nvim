--- @type LazySpec
local M = {
	"gelguy/wilder.nvim",
}

M.build = ":UpdateRemotePlugins"

M.event = {
	"CmdlineEnter",
}

function M.config()
	require("wilder").setup({
		modes = {
			"/",
			":",
		},
	})
end

return M
