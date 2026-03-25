local terminal = require("terminal")

vim.keymap.set("n", "<C-/>", terminal.toggle, { desc = "Toggle terminal" })
vim.keymap.set("n", "<leader>gg", terminal.lazygit, { desc = "Lazygit" })

vim.env.EDITOR = 'nvim --server "$NVIM" --remote'

vim.api.nvim_create_autocmd({ "VimResized" }, {
	callback = terminal.resize,
})

vim.api.nvim_create_autocmd({ "User" }, {
	pattern = "LazyGitClosed",
	callback = function()
		local ok, gitsigns = pcall(require, "gitsigns")
		if ok then
			gitsigns.refresh()
		end
	end,
})
