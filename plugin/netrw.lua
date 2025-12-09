vim.g.netrw_banner = 0
vim.g.netrw_localcopydircmd = "cp -r"
vim.g.netrw_liststyle = 3

vim.keymap.set({ "n" }, "<M-o>", function()
	for _, win in ipairs(vim.api.nvim_list_wins()) do
		local buf = vim.api.nvim_win_get_buf(win)
		if vim.bo[buf].filetype == "netrw" then
			vim.api.nvim_win_close(win, false)
			return
		end
	end

	local file = vim.fn.expand("%:t")
	vim.cmd("Vexplore")
	if file ~= "" then
		vim.fn.search("\\V" .. vim.fn.escape(file, "\\"), "cw")
	end
end, { desc = "Toggle file explorer" })
