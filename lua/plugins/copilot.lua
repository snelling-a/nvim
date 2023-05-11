local kind_icons = require("config.ui.icons").kind_icons
local logger = require("config.util.logger")

local function get_node_path()
	local node = vim.fn.exepath("node")

	if not node then
		logger.warn({ msg = "Node not found in path", title = kind_icons.Copilot .. " Copilot" })
		return
	end

	return node
end

local M = { "zbirenbaum/copilot.lua" }

M.build = ":Copilot auth"

M.cond = not vim.g.vscode

M.dependencies = {
	{
		"zbirenbaum/copilot-cmp",
		config = function(_, opts)
			local copilot_cmp = require("copilot_cmp")
			copilot_cmp.setup(opts)

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)

					if client.name == "copilot" then
						copilot_cmp._on_insert_enter(opts)
					end
				end,
				desc = "Copilot on attach",
				group = require("config.util").augroup("CopilotOnAttach"),
			})
		end,
	},
}

M.opts = { copilot_node_path = get_node_path, panel = { enabled = false }, suggestion = { enabled = true } }

return M
