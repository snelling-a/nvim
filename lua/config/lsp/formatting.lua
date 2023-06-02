local logger = require("config.util.logger")
local bind = require("config.lsp.util").bind

local DocumentFormatting = {}

local lsp_formatting = "LspFormatting"
local autoformat = true

function DocumentFormatting.toggle()
	autoformat = not autoformat

	if autoformat then
		logger.info({ msg = "Enabled format on save", title = lsp_formatting })
	else
		logger.warn({ msg = "Disabled format on save", title = lsp_formatting })
	end
end

function DocumentFormatting.format()
	local buf = vim.api.nvim_get_current_buf()
	local have_nls = package.loaded["null-ls"]
		and (#require("null-ls.sources").get_available(vim.bo.filetype, "NULL_LS_FORMATTING") > 0)

	vim.lsp.buf.format({
		bufnr = buf,
		filter = function(client)
			if client.name == "eslint" then
				return vim.cmd.EslintFixAll
			end

			if have_nls then
				return client.name == "null-ls"
			end

			return client.name ~= "null-ls"
		end,
	})
end

function DocumentFormatting.on_attach(bufnr)
	vim.api.nvim_create_autocmd("BufWritePre", {
		buffer = bufnr,
		callback = function()
			if autoformat then
				DocumentFormatting.format()
			end
		end,
		desc = "Format on save",
		group = require("config.util").augroup(lsp_formatting .. "." .. bufnr),
	})

	vim.api.nvim_create_user_command(
		"AutoformatToggle",
		function() DocumentFormatting.toggle() end,
		{ desc = "Toggle format on save", nargs = 0 }
	)

	bind(bufnr, "<leader>f", function() DocumentFormatting.format() end, "[F]ormat the current buffer")
	bind(bufnr, "<leader>tf", function() DocumentFormatting.toggle() end, "[T]oggle Auto[f]ormat")
	bind(bufnr, "<leader>sw", function() vim.cmd("noautocmd write") end, "[S]ave [w]ithout formatting")
end

return DocumentFormatting
