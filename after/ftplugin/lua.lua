vim.opt_local.colorcolumn = "120"

if vim.fn.executable("luacheck") then
	vim.cmd.compiler("luacheck")
end
