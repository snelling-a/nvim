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

local group = vim.api.nvim_create_augroup("user.lsp", {})
vim.api.nvim_create_autocmd({ "LspAttach" }, {
	group = group,
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		local bufnr = args.buf
		if client and client.server_capabilities then
			client.server_capabilities.semanticTokensProvider = nil
		end

		if client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, bufnr) then
			require("config.lsp_words").enable()
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

		if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
			if vim.g.inlay_hints == nil then
				vim.g.inlay_hints = true
			end

			local inlay_hints_group = vim.api.nvim_create_augroup("user.lsp.inlay_hints", {})

			vim.defer_fn(function()
				local mode = vim.api.nvim_get_mode().mode
				vim.lsp.inlay_hint.enable(vim.g.inlay_hints and (mode == "n" or mode == "v"), { bufnr = args.buf })
			end, 500)

			vim.api.nvim_create_autocmd({ "InsertEnter" }, {
				buffer = args.buf,
				callback = function()
					vim.lsp.inlay_hint.enable(false, { bufnr = args.buf })
				end,
				desc = "Disable inlay hints",
				group = inlay_hints_group,
			})

			vim.api.nvim_create_autocmd({ "InsertLeave" }, {
				buffer = args.buf,
				callback = function()
					vim.lsp.inlay_hint.enable(vim.g.inlay_hints, { bufnr = args.buf })
				end,
				desc = "Enable inlay hints",
				group = inlay_hints_group,
			})

			vim.keymap.set({ "n" }, "<leader>th", function()
				vim.g.inlay_hints = not vim.g.inlay_hints
				vim.lsp.inlay_hint.enable(vim.g.inlay_hints)
			end, { desc = "[T]oggle Inlay [H]ints" })
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
