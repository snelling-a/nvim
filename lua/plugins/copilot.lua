local function get_node_path()
	local title = ("%s Copilot"):format(require("config.ui.icons").kind_icons.Copilot)
	local Logger = require("config.util.logger"):new(title)

	local node = vim.fn.exepath("node")

	return node or Logger:warn("Node not found in path")
end

--- @type LazySpec
local M = {
	"github/copilot.vim",
}

M.build = ":Copilot auth"

M.event = {
	"InsertEnter",
}

function M.config()
	local filetypes = {}
	for _, v in pairs(require("config.util.constants").no_format) do
		filetypes[v] = false
	end

	vim.g.copilot_enabled = true
	vim.g.copilot_filetypes = filetypes
	vim.g.copilot_node_command = get_node_path()
end

return M
