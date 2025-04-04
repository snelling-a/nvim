if vim.g.cool_loaded then
	return
end
vim.g.cool_loaded = true

local group = vim.api.nvim_create_augroup("user.cool", {})

vim.api.nvim_create_autocmd({ "InsertEnter" }, {
	group = group,
	callback = function()
		vim.schedule(function()
			vim.cmd("nohlsearch")
		end)
	end,
})
vim.api.nvim_create_autocmd("CursorMoved", {
	group = group,
	callback = function()
		if vim.v.hlsearch == 1 and vim.fn.searchcount().exact_match == 0 then
			vim.schedule(function()
				vim.cmd.nohlsearch()
			end)
		end
	end,
})
