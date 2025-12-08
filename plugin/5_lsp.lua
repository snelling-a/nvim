vim.lsp.config("*", {
	capabilities = {
		workspace = {
			fileOperations = { didRename = true, willRename = true },
		},
		textDocument = {
			semanticTokens = { multilineTokenSupport = true },
		},
	},
	root_markers = { ".git" },
})

---@type string[]
local servers = {}

vim.iter(vim.api.nvim_get_runtime_file("lsp/*.lua", true))
	:map(function(server_config_path)
		return vim.fs.basename(server_config_path):match("^(.*)%.lua$")
	end)
	:each(function(server_name)
		vim.list_extend(servers, { server_name })
	end)

vim.lsp.enable(servers)

local group = vim.api.nvim_create_augroup("lsp", {})
vim.api.nvim_create_autocmd({ "LspAttach" }, {
	group = group,
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		local bufnr = args.buf
		if client and client.server_capabilities then
			client.server_capabilities.semanticTokensProvider = nil
		end

		if client:supports_method(vim.lsp.protocol.Methods.textDocument_declaration, bufnr) then
			vim.keymap.set({ "n" }, "gD", vim.lsp.buf.declaration, { buffer = bufnr, desc = "[G]oto [D]eclaration" })
		end

		if client:supports_method(vim.lsp.protocol.Methods.textDocument_definition, bufnr) then
			vim.keymap.set({ "n" }, "gd", vim.lsp.buf.definition, {
				buffer = bufnr,
				desc = "[G]oto [D]efinition",
			})
		end

		vim.lsp.completion.enable(true, args.data.client_id, args.buf, {
			autotrigger = true,
			cmp = function(a, b)
				local item_a = a.user_data
						and a.user_data.nvim
						and a.user_data.nvim.lsp
						and a.user_data.nvim.lsp.completion_item
					or {}
				local item_b = b.user_data
						and b.user_data.nvim
						and b.user_data.nvim.lsp
						and b.user_data.nvim.lsp.completion_item
					or {}

				local is_snip_a = item_a.kind == vim.lsp.protocol.CompletionItemKind.Snippet
				local is_snip_b = item_b.kind == vim.lsp.protocol.CompletionItemKind.Snippet

				if is_snip_a ~= is_snip_b then
					return is_snip_a
				end

				return (item_a.sortText or a.label or "") < (item_b.sortText or b.label or "")
			end,
			convert = function(item)
				return {
					abbr = item.label:gsub("%b()", ""),
				}
			end,
		})
	end,
})
