local nmap = require("config.util").nmap
local icons = require("config.ui.icons")

local Dropbar = { "Bekaboo/dropbar.nvim" }

Dropbar.opts = {
	icons = {
		kinds = { symbols = vim.tbl_map(function(icon) return icon .. " " end, icons.kind_icons) },
		ui = {
			bar = { separator = icons.misc.right .. " ", extends = icons.listchars.extends },
			menu = { separator = " ", indicator = icons.misc.selection },
		},
	},
	menu = { win_configs = { border = "rounded" } },
}

function Dropbar.config(_, opts)
	local dropbar = require("dropbar")
	local api = require("dropbar.api")

	dropbar.setup(opts)

	nmap("<leader>;", api.pick)
	nmap("[s", api.goto_context_start, { desc = "Dropbar: go to context [S]tart" })
	nmap("]s", api.select_next_context, { desc = "Dropbar: [S]elect next context" })
end

return Dropbar
