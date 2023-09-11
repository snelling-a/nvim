local kind_icons = require("config.ui.icons").kind_icons
local Logger = require("config.util.logger"):new(kind_icons.Copilot .. " Copilot")

local function get_node_path()
	local node = vim.fn.exepath("node")

	if not node then
		Logger:warn("Node not found in path")
		return
	end

	return node
end

--- @type LazySpec
local M = {
	"zbirenbaum/copilot.lua",
}

M.cond = not vim.g.vscode

M.build = ":Copilot auth"

M.event = "BufAdd"

M.dependencies = {
	{
		"zbirenbaum/copilot-cmp",
		config = function(_, opts)
			local copilot_cmp = require("copilot_cmp")
			copilot_cmp.setup(opts)

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id) or {}

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

M.opts = {
	copilot_node_path = get_node_path,
	panel = {
		enabled = false,
	},
	suggestion = {
		enabled = true,
	},
}

return M
