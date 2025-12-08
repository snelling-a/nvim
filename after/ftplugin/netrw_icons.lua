local loaded = false

if loaded then
	return
end

vim.api.nvim_create_autocmd("TextChanged", {
	callback = function(opts)
		require("netrw_icons").add_icons(opts.buf)
	end,
	desc = "[Netrw] add icons to Netrw",
	buffer = vim.api.nvim_get_current_buf(),
})
