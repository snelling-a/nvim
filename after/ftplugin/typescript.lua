vim.opt.wildignore:append({
	"**/build/**",
	"**/coverage/**",
	"**/dist/**",
	"**/node_modules/**",
	"**/target/**",
	"**/vendor/**",
})

if vim.fn.executable("tsc") then
	vim.cmd.compiler("tsc")

require("config.util").nmap("<leader>tt", function()
	vim.cmd.make()
	vim.cmd([[redraw!]])
end, { desc = ":make tsc" })
end

vim.opt_local.matchpairs:append({ "=:;" })
