local opt = vim.opt_local

opt.wildignore:append({
	"**/build/**",
	"**/coverage/**",
	"**/dist/**",
	"**/node_modules/**",
	"**/target/**",
	"**/vendor/**",
})

if vim.fn.executable("tsc") then
	vim.cmd.compiler("tsc")

	require("keymap").leader("tt", function()
		vim.cmd.make()
		vim.cmd.redraw({
			bang = true,
		})
	end, {
		desc = ":make tsc",
	})
end
