if vim.fn.executable("eslint_d") == 1 then
	vim.cmd.compiler("eslint_d")
elseif vim.fn.executable("eslint") == 1 then
	vim.cmd.compiler("eslint")
end
