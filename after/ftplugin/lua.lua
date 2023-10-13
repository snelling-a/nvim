local opt = vim.opt_local

opt.colorcolumn = "120"
opt.keywordprg = ":vertical help"

if vim.fn.executable("luacheck") then
	vim.cmd.compiler("luacheck")
end

vim.api.nvim_create_user_command("FormatLua", function()
	vim.api.nvim_exec2(
		[[
            silent! %s/\(\s\+\)\?\(\w\?\(,\|(\)\?\s\?\(=\s\)\?{\)\(\s\S\)/\1\2\r\5/
            silent! %s/\s\+{\s\?{/{\r{/
            silent! %s/{\n\{2,\}/{\r/
            ]],
		{
			output = false,
		}
	)

	vim.cmd.write()
end, {
	desc = "Ensure consistent formatting of lua tables",
	force = true,
})
