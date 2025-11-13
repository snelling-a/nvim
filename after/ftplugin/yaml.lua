vim.opt_local.colorcolumn = "80"
vim.opt_local.cursorcolumn = true

vim.api.nvim_buf_create_user_command(vim.api.nvim_get_current_buf(), "SortYAML", function()
	vim.cmd([[%!yq 'sort_keys(..)' %]])
end, { desc = "Sort YAML with `yq`" })
