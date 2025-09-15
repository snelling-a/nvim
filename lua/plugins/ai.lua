---@type LazySpec
return {
	"nvim-mini/mini.ai",
	dependencies = { "nvim-mini/mini.extra" },
	event = { "LazyFile" },
	config = function()
		local ai = require("mini.ai")
		local gen_ai_spec = require("mini.extra").gen_ai_spec

		ai.setup({
			n_lines = 500,
			custom_textobjects = {
				U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }),
				c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
				d = { "%f[%d]%d+" },
				e = {
					{ "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
					"^().*()$",
				},
				f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
				g = gen_ai_spec.buffer(),
				o = ai.gen_spec.treesitter({
					a = { "@block.outer", "@conditional.outer", "@loop.outer" },
					i = { "@block.inner", "@conditional.inner", "@loop.inner" },
				}),
				t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
				u = ai.gen_spec.function_call(),
			},
		})
	end,
}
