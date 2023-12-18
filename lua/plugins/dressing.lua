---@type LazySpec
local M = { "stevearc/dressing.nvim" }

M.cmd = { "GH" }

M.event = require("util").constants.lazy_event

M.opts = function(_, opts)
	local Icons = require("ui.icons")

	return require("util").tbl_extend_force(opts, {
		input = {
			default_prompt = require("util").get_prompt(""),
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
				listchars = Icons.listchars,
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
				codeaction = function(code_action)
					local title = code_action.action.title:gsub("\r\n", "\\r\\n")
					local client = vim.lsp.get_client_by_id(code_action.ctx.client_id) or ""
					local client_icon = Icons.servers[client.name] or ""
					return ("%s  [%s]"):format(client_icon, title:gsub("\n", "\\n"))
				end,
			},
			fzf_lua = {
				winopts = {
					height = 0.4,
					width = 0.4,
				},
			},
			get_config = function(config_opts)
				config_opts.propt = config_opts.prompt and config_opts.prompt or ""
				if
					config_opts.kind == "codeaction"
					or (
						config_opts.prompt
						and config_opts.prompt:match("Do you want to modify the require path") ~= nil
					)
				then
					return {
						backend = "builtin",
					}
				end
			end,
			trim_prompt = false,
		},
	})
end

return M
