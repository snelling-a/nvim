---@param client vim.lsp.Client
---@param bufnr integer
---@param cmd string
---@return nil
local function command_factory(client, bufnr, cmd)
	return client:exec_cmd({
		title = ("Markdown-Oxide-%s"):format(cmd),
		command = "jump",
		arguments = { cmd },
	}, { bufnr = bufnr })
end

---@type vim.lsp.Config
return {
	cmd = { "markdown-oxide" },
	filetypes = { "markdown" },
	on_attach = function(client, bufnr)
		if not client.config.root_dir then
			client:stop()
			return
		end
		for _, cmd in ipairs({ "today", "tomorrow", "yesterday" }) do
			vim.api.nvim_buf_create_user_command(
				bufnr,
				"Lsp" .. require("util").capitalize_first_letter(cmd),
				function()
					command_factory(client, bufnr, cmd)
				end,
				{ desc = ("Open %s daily note"):format(cmd) }
			)
		end
	end,
	root_markers = { ".moxide.toml", ".obsidian" },
	single_file_support = true,
}
