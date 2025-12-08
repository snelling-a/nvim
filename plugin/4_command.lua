vim.api.nvim_create_user_command("Remove", function()
	vim.cmd([[!rm %]])
end, {})
