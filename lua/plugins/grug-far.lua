vim.pack.add({ { src = "https://github.com/MagicDuck/grug-far.nvim" } })

require("grug-far").setup({ wrap = false })

vim.keymap.set("n", "<leader>sr", "<cmd>GrugFar<cr>", { desc = "Search and replace" })
vim.keymap.set({ "v", "x" }, "<leader>sr", function()
	local selection = table.concat(vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos(".")), "\n")
	require("grug-far").open({ prefills = { search = selection }, visualSelectionUsage = "ignore" })
end, { desc = "Search and replace within selection" })
