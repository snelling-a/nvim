local opt = vim.opt_local

opt.colorcolumn = "120"
opt.keywordprg = ":vertical help"

if vim.fn.executable("luacheck") then
	vim.cmd.compiler("luacheck")
end
