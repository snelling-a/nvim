local kind_icons = require("utils.icons").kind_icons
local logger = require("utils.logger")

local get_node_path = function()
	local node = vim.fn.exepath("node")

	if not node then
		logger.warn({ msg = "Node not found in path", title = kind_icons.Copilot })
		return
	end

	return node
end

require("copilot").setup({ copilot_node_path = get_node_path })
