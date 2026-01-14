vim.pack.add({ { src = "https://github.com/jrop/tuis.nvim" } }, { load = false })

vim.keymap.set("n", "<leader>m", function()
	vim.cmd.packadd("tuis.nvim")
	require("tuis").choose()
end, { desc = "Choose Morph UI" })
