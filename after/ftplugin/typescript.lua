vim.opt_local.wildignore:append({
	"**/build/**",
	"**/coverage/**",
	"**/dist/**",
	"**/node_modules/**",
	"**/target/**",
	"**/vendor/**",
})

if vim.fn.executable("tsc") then
	vim.cmd.compiler("tsc")
end
