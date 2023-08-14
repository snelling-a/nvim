vim.opt.wildignore:append({
	"**/build/**",
	"**/coverage/**",
	"**/dist/**",
	"**/node_modules/**",
	"**/target/**",
	"**/vendor/**",
})

vim.cmd.compiler("typescript")

vim.keymap.set("n", "<leader>tt", function()
	vim.cmd.make()
	vim.cmd.redraw({ bang = true })
end, {})
