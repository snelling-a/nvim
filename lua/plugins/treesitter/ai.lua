---@type LazySpec
local M = { "echasnovski/mini.ai" }

M.keys = {
	{ "a", mode = { "x", "o" }, desc = "[A]round text object" },
	{ "i", mode = { "x", "o" }, desc = "[I]nside text object" },
}

function M.opts()
	local ai = require("mini.ai")

	return {
		custom_textobjects = {
			o = ai.gen_spec.treesitter({
				a = { "@block.outer", "@conditional.outer", "@loop.outer" },
				i = { "@block.inner", "@conditional.inner", "@loop.inner" },
			}, {}),
			f = ai.gen_spec.treesitter({
				a = "@function.outer",
				i = "@function.inner",
			}, {}),
			c = ai.gen_spec.treesitter({
				a = "@class.outer",
				i = "@class.inner",
			}, {}),
			t = {
				"<([%p%w]-)%f[^<%w][^<>]->.-</%1>",
				"^<.->().*()</[^/]->$",
			},
		},
	}
end

return M
