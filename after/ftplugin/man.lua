vim.opt_local.modified = false
vim.opt_local.showbreak = ""
vim.opt_local.showtabline = 0
vim.opt_local.spell = false
vim.opt_local.wrap = true

local bufnr = vim.api.nvim_get_current_buf()
local map = require("user.keymap.util").map("Man")

map({ "n" }, "q", function()
	vim.cmd.quitall()
end)

---@param lhs "u"|"d" Left-hand side |{lhs}| of the mapping - [u]p or [d]own
---@return nil
local function scroll(lhs)
	local rhs = ("<C-%s>"):format(lhs)
	return map({ "n" }, lhs, rhs, { buffer = bufnr, nowait = true, desc = ("use %q as %q"):format(lhs, rhs) })
end

scroll("d")
scroll("u")

map({ "n" }, "ht", function()
	vim.cmd.lvimgrep("/\\v^\\s*--?\\w+/j %")
	vim.cmd.lopen()
end, { buffer = bufnr, desc = "Generate list of cli flags" })
