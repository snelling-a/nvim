local icons = require("config.ui.icons")

local M = { "simrat39/symbols-outline.nvim" }

M.cmd = "SymbolsOutline"

local function get_symbols()
	local symbols = {}

	for k, v in pairs(icons.kind_icons) do
		symbols[k] = { icon = v }
	end

	return symbols
end

M.opts = {
	fold_markers = { icons.misc.right, icons.misc.down },
	position = "left",
	symbols = get_symbols(),
}

return M
