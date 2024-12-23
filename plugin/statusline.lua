if vim.g.vscode or vim.g.status then
	return
end
vim.g.status = true

vim.o.laststatus = 0
Config.autocmd.create_autocmd("User", {
	callback = function()
		vim.o.laststatus = 3
		_G.statusline = require("statusline")
		_G.statuscolumn = require("statuscolumn")

		vim.o.statusline = "%!v:lua.statusline()"
		vim.o.statuscolumn = "%!v:lua.statuscolumn()"

		local opts = { flush = true, statuscolumn = true, statusline = true }

		vim.api.nvim_create_autocmd("DiagnosticChanged", {
			callback = function()
				vim.api.nvim__redraw(opts)
			end,
		})

		vim.api.nvim_create_autocmd("User", {
			pattern = "GitSignsUpdate",
			callback = function()
				vim.api.nvim__redraw(opts)
			end,
		})
	end,
	once = true,
	pattern = "InitStatus",
})
