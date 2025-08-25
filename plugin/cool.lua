if vim.g.cool_loaded then
	return
end
vim.g.cool_loaded = true

local group = require("user.autocmd").augroup("cool")

local function clear_hlsearch()
	if vim.v.hlsearch == 1 then
		vim.cmd.nohlsearch()
	end
end

vim.api.nvim_create_autocmd("InsertEnter", {
	callback = function()
		vim.schedule(clear_hlsearch)
	end,
	desc = "Clear search highlight on insert enter",
	group = group,
})

vim.api.nvim_create_autocmd({ "CursorMoved" }, {
	callback = function()
		if vim.fn.searchcount().exact_match == 0 then
			vim.schedule(clear_hlsearch)
		end
	end,
	desc = "Clear search highlight on cursor move",
	group = group,
})
