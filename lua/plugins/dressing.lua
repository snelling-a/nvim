--- @type LazySpec
local M = {
	"stevearc/dressing.nvim",
}

M.opts = {
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
		win_opts = {
			listchars = require("config.ui.icons").listchars,
		},
	},
	select = {
		backend = {
			"fzf_lua",
			"builtin",
		},
		builtin = {
			win_opts = {
				winblend = 30,
			},
		},
		format_item_override = {
			codeaction = function(action_tuple)
				local title = action_tuple[2].title:gsub("\r\n", "\\r\\n")
				local client = vim.lsp.get_client_by_id(action_tuple[1]) or ""
				local client_icon = require("config.ui.icons").servers[client.name] or ""
				return ("%s  [%s]"):format(client_icon, title:gsub("\n", "\\n"))
			end,
		},
		fzf_lua = {
			winopts = {
				height = 0.4,
				width = 0.4,
			},
		},
		--- @param opts {prompt:string,kind:string?}
		get_config = function(opts)
			if opts.kind == "codeaction" or opts.prompt:match("Do you want to modify the require path") ~= nil then
				return {
					backend = "builtin",
				}
			end
		end,
		trim_prompt = false,
	},
}

return M
