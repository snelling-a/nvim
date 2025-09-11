local map = require("user.keymap.util").map("GitGraph")

map({ "n" }, "q", function()
	vim.cmd("bd!")
end, { desc = "Close GitGraph" })
