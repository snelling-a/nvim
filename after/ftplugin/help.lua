vim.opt_local.number = true
vim.opt_local.numberwidth = 1
vim.opt_local.relativenumber = true

local bufnr = vim.api.nvim_get_current_buf()

local map = require("user.keymap.util").map("Help")

map({ "n" }, "<CR>", "<C-]>", { buffer = bufnr, desc = "Jump to the definition of the keyword under the cursor." })
map({ "n" }, "ht", function()
	vim.cmd.lvimgrep("/\\v.*\\*\\S+\\*$/j %")
	vim.cmd.lopen()
end, { buffer = bufnr, desc = "Helptags to location-list" })

---@param lhs string Left-hand side |{lhs}| of the mapping.
---@param rhs string Right-hand side |{rhs}| of the mapping
---@param item string Search item
local function search_map(lhs, rhs, item)
	map({ "n" }, "[" .. lhs, function()
		vim.fn.search(rhs, "wb")
	end, { buffer = bufnr, desc = "Previous" .. item })
	map({ "n" }, "]" .. lhs, function()
		vim.fn.search(rhs, "w")
	end, { buffer = bufnr, desc = "Next" .. item })
end

search_map("L", "|\\S\\{-}|", "|link|")
search_map("h", "^==============================", "heading")
search_map("l", "\\*\\S\\{-}\\*", "*link*")
