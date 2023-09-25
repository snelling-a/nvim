local opt_local = vim.opt_local

opt_local.colorcolumn = "80"
opt_local.cursorcolumn = true

vim.api.nvim_create_user_command("SortYAML", function() vim.cmd([[%!yq 'sort_keys(..)' %]]) end, {
	desc = "Sort yaml keys alphabetically",
})
