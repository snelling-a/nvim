vim.opt_local.cursorcolumn = true
vim.opt_local.conceallevel = 3
vim.opt_local.cursorlineopt = "number"

vim.api.nvim_buf_create_user_command(vim.api.nvim_get_current_buf(), "SortJSON", function()
	vim.cmd([[%!jq . --sort-keys]])
end, {
	desc = "Sort JSON with `jq`",
})

function _G.JsonFolds()
	local line = vim.fn.getline(vim.v.lnum)
	-- let l:lline = split(l:line, '\zs')
	local inc = vim.fn.count(line, "{")
	local dec = vim.fn.count(line, "}")
	local level = inc - dec
	if level == 0 then
		return "="
	elseif level > 0 then
		return "a" .. level
	elseif level < 0 then
		return "s" .. -level
	end
end

vim.opt_local.conceallevel = 0
vim.opt_local.foldnestmax = 5
vim.opt_local.foldmethod = "marker"
vim.opt_local.foldmarker = "{,}"

vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "v:lua.JsonFolds()"
vim.opt_local.foldenable = false
