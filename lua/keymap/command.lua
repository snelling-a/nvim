local feedkeys = require("keymap.util").feedkeys
local map = require("keymap.util").cmap

map("make", function()
	vim.cmd.make({ bang = true })
	feedkeys("<Enter>")
	vim.cmd.copen()
end, { desc = "Make and open the quickfix list" })

local function wild(lhs, rhs)
	map(lhs, function()
		if vim.fn.wildmenumode() == 1 then
			return lhs
		else
			return rhs
		end
	end, { desc = ("Navigate %s in wildmenu"):format(rhs), expr = true, silent = false })
end

wild("<C-n>", "<down>")
wild("<C-p>", "<up>")
