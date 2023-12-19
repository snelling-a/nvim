---@type LazySpec
local M = { "L3MON4D3/LuaSnip" }

M.build = (not jit.os:find("Windows"))
		and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
	or nil

M.dependencies = {
	"rafamadriz/friendly-snippets",
	{
		"dsznajder/vscode-es7-javascript-react-snippets",
		build = "yarn install --frozen-lockfile && yarn compile",
	},
}

M.event = { "InsertEnter" }

M.opts = {
	delete_check_events = "InsertLeave",
	history = true,
}

function M.config(_, opts)
	local luasnip = require("luasnip")
	luasnip.setup(opts)

	for _, type in pairs({ "vscode", "lua" }) do
		require(("luasnip.loaders.from_%s"):format(type)).lazy_load()
	end

	vim.api.nvim_create_autocmd("User", {
		callback = function()
			local trigger = not luasnip.expand_or_locally_jumpable()

			vim.b.copilot_suggestion_auto_trigger = trigger
			vim.b.copilot_suggestion_hidden = not trigger
		end,
		desc = "Disable Copilot suggestions when Luasnip is active",
		group = require("autocmd").augroup("CopilotSnippetSuggestions"),
		pattern = { "LuasnipInsertNodeEnter", "LuasnipInsertNodeLeave" },
	})
end

return M
