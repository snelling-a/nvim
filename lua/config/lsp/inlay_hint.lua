_G.INLAY_HINTS = true

--- @param bufnr integer
local function setup_user_commands(bufnr)
	local Logger = require("config.util.logger"):new("Inlay hints")

	vim.api.nvim_create_user_command("InlayHintToggle", function()
		_G.INLAY_HINTS = not _G.INLAY_HINTS

		vim.lsp.inlay_hint(bufnr, _G.INLAY_HINTS)

		local state = require("config.lsp.util").get_state(_G.INLAY_HINTS)
		local str = ("Inlay hints have been %s."):format(state)

		if _G.INLAY_HINTS then
			Logger:info(str)
		else
			Logger:warn(str)
		end
	end, {
		desc = "Toggle LSP inlay hints",
	})
end

local M = {}

--- @param client lsp.Client
--- @param bufnr integer
function M.on_attach(client, bufnr)
	local method = vim.lsp.protocol.Methods.textDocument_inlayHint

	local ok, inlay_hint_supported = pcall(function() return client.supports_method(method) end)

	if not ok or not inlay_hint_supported then
		return
	end

	vim.lsp.inlay_hint(bufnr, _G.INLAY_HINTS)

	setup_user_commands(bufnr)
end

return M
