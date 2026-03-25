local action = require("vscode").action

require("plugins.ts-autotag")
require("plugins.mini")

vim.keymap.set("n", "<leader>ff", function()
	action("workbench.action.quickOpen")
end)
vim.keymap.set("n", "<leader>ss", function()
	action("workbench.action.gotoSymbol")
end)

vim.api.nvim_create_autocmd({ "VimEnter" }, {
	callback = function()
		vim.keymap.set("n", "]d", function()
			action("editor.action.marker.next")
		end)
		vim.keymap.set("n", "[d", function()
			action("editor.action.marker.prev")
		end)
		vim.keymap.set("n", "]]", function()
			action("editor.action.wordHighlight.next")
		end)
		vim.keymap.set("n", "[[", function()
			action("editor.action.wordHighlight.prev")
		end)
	end,
	once = true,
})
