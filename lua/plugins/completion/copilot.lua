---@type LazySpec
local M = { "zbirenbaum/copilot.lua" }

M.build = ":Copilot auth"

M.cmd = { "Copilot" }

M.event = { "InsertEnter" }

M.opts = {
	filetypes = { markdown = true, help = true },
	panel = { enabled = false },
	suggestion = { enabled = false },
}

return {
	M,
	{
		"nvim-cmp",
		dependencies = {
			{
				"zbirenbaum/copilot-cmp",
				dependencies = "copilot.lua",
				opts = {},
				config = function(_, opts)
					local copilot_cmp = require("copilot_cmp")
					copilot_cmp.setup(opts)
					require("lsp").on_attach(function(client)
						if client.name == "copilot" then
							copilot_cmp._on_insert_enter({})
						end
					end)
				end,
			},
		},
		---@param opts cmp.ConfigSchema
		opts = function(_, opts)
			table.insert(opts.sources, 1, {
				name = "copilot",
				group_index = 1,
				priority = 100,
			})
		end,
	},
}
