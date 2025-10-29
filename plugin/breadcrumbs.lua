if vim.g.breadcrumbs then
	return
end
vim.g.breadcrumbs = true

local Breadcrumbs = require("user.lsp.breadcrumbs")

local group = require("user.autocmd").augroup("breadcrumbs")

vim.api.nvim_create_autocmd({ "CursorMoved" }, {
	callback = Breadcrumbs.winbar.get_winbar,
	desc = "Update breadcrumbs in winbar",
	group = group,
})

vim.api.nvim_create_autocmd({ "BufWritePost", "TextChanged", "LspAttach", "BufEnter", "WinEnter" }, {
	callback = function(args)
		Breadcrumbs.symbols.refresh_symbols(args.buf)
	end,
	desc = "Refresh document symbols for breadcrumbs",
	group = group,
})
