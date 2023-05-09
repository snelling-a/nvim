local icons = require("config.ui.icons")

local M = { "stevearc/dressing.nvim" }

M.opts = {
	input = {
		default_prompt = icons.misc.right,
		max_width = { 50, 0.3 },
		min_width = { 30, 0.2 },
	},
	select = {
		backend = { "fzf_lua", "builtin" },
		builtin = {
			width = 30,
			max_width = { 60, 0.3 },
			min_width = { 30, 0.2 },
			max_height = 0.3,
			min_height = { 10, 0.2 },
			mappings = {
				["<Esc>"] = "Close",
				["q"] = "Close",
				["<C-c>"] = "Close",
				["<CR>"] = "Confirm",
			},
		},
		get_config = function(opts)
			if opts.kind == "codeaction" then
				return { builtin = { relative = "cursor" } }
			end
		end,
	},
}

return M
