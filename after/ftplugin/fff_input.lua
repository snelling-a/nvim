local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set({ "n" }, "<C-c>", vim.cmd.close, { buf = bufnr, desc = "Close fff input window" })
