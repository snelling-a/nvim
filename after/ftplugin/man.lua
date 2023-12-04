local opt = vim.opt_local

opt.buflisted = false
opt.modified = false
opt.showbreak = ""
opt.showtabline = 0
opt.spell = false
opt.wrap = false

local bufnr = vim.api.nvim_get_current_buf()

local function keymap(lhs)
	local rhs = ("<C-%s>"):format(lhs)
	return vim.api.nvim_buf_set_keymap(0, "n", lhs, rhs, { nowait = true })
end

keymap("d")
keymap("u")

---@param lhs string
---@param rhs string|fun(...:any):(...:any)
---@param desc string
---@param opts table?
local function map(lhs, rhs, desc, opts)
	opts = vim.tbl_extend("force", opts or {}, { buffer = bufnr, desc = desc })
	require("keymap").nmap(lhs, rhs, opts)
end

map("ht", function()
	vim.cmd.lvimgrep("/\\v^\\s*--?\\w+/j %")
	vim.cmd.lopen()
end, "Generate list of cli flags", { silent = true })

local function close()
	local Util = require("util")

	if not Util.is_man() then
		return
	end

	if not Util.are_buffers_listed() or Util.is_loc_list(2) then
		return vim.cmd.quitall()
	else
		return vim.cmd.bwipeout()
	end
end

map("q", function()
	return require("autocmd").easy_quit(close)
end, "Easy [q]uit")
