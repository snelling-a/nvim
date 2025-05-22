---@type LazySpec
return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{ "<leader>f", desc = "[F]ormat buffer" },
	},
	---@type conform.setupOpts
	opts = {
		format_on_save = function(bufnr)
			if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
				return
			end

			return { timeout_ms = 500, lsp_format = "fallback" }
		end,
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
			sqlfluff = { args = { "format", "--dialect=ansi", "-" } },
		},
		formatters_by_ft = {
			css = { "prettierd", "prettier" },
			html = { "prettier", "prettierd" },
			javascript = { "prettierd", "prettier" },
			javascriptreact = { "prettierd", "prettier" },
			json = { "prettierd" },
			json5 = { "prettierd" },
			jsonc = { "prettierd" },
			lua = { "stylua" },
			markdown = { "prettierd", "prettier", "markdownlint-cli2", "markdown-toc" },
			sh = { "shfmt" },
			sql = { "sqlfmt" },
			typescript = { "prettierd", "prettier" },
			typescriptreact = { "prettierd", "prettier" },
			yaml = { "yamlfmt", "yq" },
		},
		notify_on_error = false,
	},
	config = function(_, opts)
		local conform = require("conform")
		conform.setup(opts)

		vim.keymap.set("n", "<leader>f", function()
			conform.format({ async = true, lsp_format = "fallback" })
		end, { desc = "Conform: Format Buffer" })

		vim.api.nvim_create_user_command("FormatDisable", function(args)
			if args.bang then
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
