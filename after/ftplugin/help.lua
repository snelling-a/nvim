vim.treesitter.start()
local Keymap = require("keymap")

local opt = vim.opt_local

opt.keywordprg = ":vertical help"
opt.number = true
opt.numberwidth = 1
opt.relativenumber = true
opt.statuscolumn = require("ui.status.column").basic

local bufnr = vim.api.nvim_get_current_buf()

---@param lhs string
---@param rhs string|function
---@param desc string
local function map(lhs, rhs, desc)
	Keymap.nmap(lhs, rhs, { buffer = bufnr, desc = desc })
end

map("<CR>", "<C-]>", "Go to definition")
map("]t", "ta", "Go to next tag")
map("[t", "<C-t>", "Go to prev tag")

map("ht", function()
	vim.cmd.lvimgrep("/\\v.*\\*\\S+\\*$/j %")
	vim.cmd.lopen()

	if not require("bqf.preview.handler").hideWindow() then
		vim.cmd.normal("P")
	end
end, "Helptags to quickfix")

---@param lhs string
---@param rhs string
---@param item string
local function search_map(lhs, rhs, item)
	Keymap.unimpaired(lhs, {
		left = function()
			vim.fn.search(rhs, "wb")
		end,
		right = function()
			vim.fn.search(rhs, "w")
		end,
	}, {
		base = "",
		text = {
			left = ("Previous %s"):format(item),
			right = ("Next %s"):format(item),
		},
	}, { buffer = bufnr })
	Keymap.center.scroll()
end

search_map("L", "|\\S\\{-}|", "|link|")
search_map("h", "^==============================", "heading")
search_map("l", "\\*\\S\\{-}\\*", "*link*")
