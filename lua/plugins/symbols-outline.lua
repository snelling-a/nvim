local Icons = require("config.ui.icons")

local M = { "simrat39/symbols-outline.nvim" }

M.cmd = "SymbolsOutline"

local function get_symbols()
	local symbols = {}

	for k, v in pairs(Icons.kind_icons) do
		symbols[k] = { icon = v }
	end

	return symbols
end

M.opts = {
	fold_markers = { Icons.misc.right, Icons.misc.down },
	position = "left",
	symbols = get_symbols(),
}

return M
