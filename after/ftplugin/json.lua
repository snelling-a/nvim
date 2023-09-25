local opt = vim.opt_local

opt.cursorcolumn = true
opt.conceallevel = 1
opt.cursorlineopt = "number"

vim.api.nvim_create_user_command("SortJSON", function() vim.cmd([[%!jq . --sort-keys]]) end, {
	desc = "Sort json keys alphabetically",
})

