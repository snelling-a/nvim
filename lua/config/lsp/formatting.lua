local logger = require("config.util.logger")

local Formatting = {}

local lsp_formatting = "LspFormatting"
local autoformat = true

function Formatting.toggle()
	autoformat = not autoformat

	if autoformat then
		logger.info({ msg = "Enabled format on save", title = lsp_formatting })
	else
		logger.warn({ msg = "Disabled format on save", title = lsp_formatting })
	end
end

function Formatting.format()
	local buf = vim.api.nvim_get_current_buf()
	local have_nls = package.loaded["null-ls"]
		and (#require("null-ls.sources").get_available(vim.bo.filetype, "NULL_LS_FORMATTING") > 0)

	vim.lsp.buf.format({
		bufnr = buf,
		filter = function(client)
			if have_nls then
				return client.name == "null-ls"
			end
			return client.name ~= "null-ls"
		end,
	})
end

function Formatting.on_attach(buf)
	vim.api.nvim_create_autocmd("BufWritePre", {
		buffer = buf,
		callback = function()
			if autoformat then
				Formatting.format()
			end
		end,
		desc = "Format on save",
		group = require("config.util").augroup(lsp_formatting .. "." .. buf),
	})

	vim.api.nvim_create_user_command(
		"AutoformatToggle",
		function() Formatting.toggle() end,
		{ desc = "Toggle format on save", nargs = 0 }
	)
end

return Formatting
