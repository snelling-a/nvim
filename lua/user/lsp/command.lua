local Util = require("user.lsp.util")

vim.api.nvim_create_user_command("LspStop", function(args)
	for _, stop_client in ipairs(vim.lsp.get_clients({ name = args.fargs[1] })) do
		stop_client:stop()
	end
end, {
	nargs = "?",
	complete = Util.get_client_names,
})

vim.api.nvim_create_user_command("LspRestart", function(args)
	for _, restart_client in ipairs(vim.lsp.get_clients({ name = args.fargs[1] })) do
		local bufs = vim.lsp.get_client_by_id(restart_client.id).attached_buffers

		restart_client:stop()

		vim.wait(30000, function()
			return vim.lsp.get_client_by_id(restart_client.id) == nil
		end)

		local client_id = vim.lsp.start(restart_client.config, { attach = false })

		if client_id then
			for _, buf in ipairs(bufs) do
				vim.lsp.buf_attach_client(buf, client_id)
			end
		end
	end
end, {
	nargs = "?",
	complete = Util.get_client_names,
})

vim.api.nvim_create_user_command("LspInfo", function()
	vim.api.nvim_command("checkhealth vim.lsp")
end, {
	desc = "Restart all LSP servers",
})

vim.api.nvim_create_user_command("LspStart", function(args)
	vim.lsp.start(vim.lsp.get_server_config(args.fargs[1]))
	-- vim.cmd("runtime! lsp/" .. args.fargs[1] .. ".lua")
end, {
	complete = Util.get_all_client_names,
	nargs = "?",
})
