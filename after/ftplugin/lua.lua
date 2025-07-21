vim.opt_local.colorcolumn = "120"
vim.opt_local.spellcapcheck = ""

if vim.fn.executable("luacheck") then
	vim.cmd.compiler("luacheck")
end
