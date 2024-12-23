---@type LazySpec
return {
	"stevearc/conform.nvim",
	event = { "LazyFile" },
	keys = {
		{ "<leader>f", desc = "Format Buffer" },
	},
	init = function()
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
	config = function()
		local conform = require("conform")

		---@return conform.FiletypeFormatterInternal
		local function javascript_typescript_formatter()
			if not Config.lsp.is_deno() then
				return { "prettierd", "prettier" }
			end

			return {}
		end

		conform.setup({
			format_on_save = function(bufnr)
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end

				return { timeout_ms = 500, lsp_format = "fallback" }
			end,
			formatters_by_ft = {
				css = { "prettierd", "prettier" },
				html = { "prettier", "prettierd" },
				javascript = javascript_typescript_formatter,
				javascriptreact = javascript_typescript_formatter,
				json = { "prettierd" },
				json5 = { "prettierd" },
				jsonc = { "prettierd" },
				lua = { "stylua" },
				markdown = { "prettierd", "prettier", "markdownlint-cli2", "markdown-toc" },
				sh = { "shfmt" },
				sql = { "sqlfluff" },
				toml = { "taplo" },
				typescript = javascript_typescript_formatter,
				typescriptreact = javascript_typescript_formatter,
				yaml = { "yamlfmt", "yq" },
			},
			formatters = {
				["markdownlint-cli2"] = {
					condition = function(_, ctx)
						---@param diagnostic vim.Diagnostic
						---@return boolean
						local diag = vim.tbl_filter(function(diagnostic)
							return diagnostic.source == "markdownlint"
						end, vim.diagnostic.get(ctx.buf))

						return #diag > 0
					end,
				},
				["markdown-toc"] = {
					condition = function(_, ctx)
						for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
							if line:find("<!%-%- toc %-%->") then
								return true
							end
						end
						return false
					end,
				},
				sqlfluff = {
					args = { "format", "--dialect=ansi", "-" },
				},
			},
		})

		vim.keymap.set("n", "<leader>f", function()
			conform.format({ async = true, lsp_format = "fallback" })
		end, { desc = "Conform: Format Buffer" })

		vim.api.nvim_create_user_command("FormatDisable", function(ctx)
			if ctx.bang then
				vim.b.disable_autoformat = true
			else
				vim.g.disable_autoformat = true
			end
		end, {
			bang = true,
			desc = "Disable autoformat-on-save",
		})

		vim.api.nvim_create_user_command("FormatEnable", function()
			vim.b.disable_autoformat = false
			vim.g.disable_autoformat = false
		end, {
			desc = "Re-enable autoformat-on-save",
		})
	end,
}
