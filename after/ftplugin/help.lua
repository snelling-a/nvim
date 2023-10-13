vim.treesitter.start()

local Util = require("config.util")

local opt = vim.opt_local

opt.keywordprg = ":vertical help"
opt.number = true
opt.numberwidth = 1
opt.relativenumber = true

opt.statuscolumn = [[%#NonText#%{&nu?(&rnu&&v:relnum?v:relnum:v:lnum):''}%=]]
	.. require("config.ui.icons").fillchars.foldsep
	.. "%T"

Util.nmap("<CR>", "<C-]>", {
	desc = "Go to definition",
})
Util.nmap("]t", "ta", {
	desc = "Go to next tag",
})
Util.nmap("[t", "<C-t>", {
	desc = "Go to prev tag",
})

Util.nmap("ht", function()
	vim.cmd.vimgrep("/\\v.*\\*\\S+\\*$/j %")
	vim.cmd.copen()

	if not require("bqf.preview.handler").showWindow() then
		vim.cmd.normal("P")
	end
end, {
	desc = "Helptags to quickfix",
})

--- @param lhs string
--- @param rhs string
--- @param item string
local function search_map(lhs, rhs, item)
	local U = require("config.keymap.unimpaired")
	local bufnr = vim.api.nvim_get_current_buf()

	U.unimapired(lhs, {
		left = function() vim.fn.search(rhs, "wb") end,
		right = function() vim.fn.search(rhs, "w") end,
	}, {
		base = "",
		text = {
			left = ("Previous %s"):format(item),
			right = ("Next %s"):format(item),
		},
	}, { buffer = bufnr })
	Util.scroll_center()
end

search_map("L", "|\\S\\{-}|", "|link|")
search_map("h", "^==============================", "heading")
search_map("l", "\\*\\S\\{-}\\*", "*link*")
