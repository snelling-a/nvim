--- @type LazySpec
local M = {
	"stevearc/dressing.nvim",
}

M.lazy = true

M.opts = {
	get_config = function(opts)
		if opts.kind == "codeaction" then
			return {
				builtin = {
					relative = "cursor",
				},
			}
		end
	end,
	input = {
		default_prompt = require("config.util").get_prompt(""),
		mappings = {
			i = {
				["<C-p>"] = "HistoryPrev",
				["<C-n>"] = "HistoryNext",
			},
		},
		max_width = {
			50,
			0.3,
		},
		min_width = {
			30,
			0.2,
		},
	},
	nui = {
		relative = "cursor",
	},
	select = {
		backend = {
			"fzf_lua",
			"builtin",
		},
		builtin = {
			width = 30,
			max_width = {
				60,
				0.3,
			},
			min_width = {
				30,
				0.2,
			},
			max_height = 0.3,
			min_height = {
				10,
				0.2,
			},
		},
		fzf_lua = {
			winopts = {
				height = 0.4,
				width = 0.4,
			},
		},
		trim_prompt = false,
	},
}

function M.init()
	local load = require("lazy").load
	local ui = vim.ui

	--- @diagnostic disable-next-line: duplicate-set-field
	ui.select = function(...)
		load({
			plugins = {
				"dressing.nvim",
			},
		})
		return ui.select(...)
	end

	--- @diagnostic disable-next-line: duplicate-set-field
	ui.input = function(...)
		load({
			plugins = {
				"dressing.nvim",
			},
		})
		return ui.input(...)
	end
end

return M
