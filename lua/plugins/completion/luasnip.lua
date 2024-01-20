---@param direction "next" | "previous"
local get_desc = function(direction)
	return ("Jump to %s snippet placeholder"):format(direction)
end
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

M.keys = {
	{ "<tab>", desc = get_desc("next"), mode = { "i", "s" } },
	{ "<s-tab>", desc = get_desc("previous"), mode = { "s" } },
}

M.opts = {
	delete_check_events = "TextChanged",
	history = true,
}

function M.config(_, opts)
	local luasnip = require("luasnip")
	luasnip.setup(opts)
	local Keymap = require("keymap")

	for _, type in pairs({ "vscode", "lua" }) do
		require(("luasnip.loaders.from_%s"):format(type)).lazy_load()
	end

	Keymap.imap("<tab>", function()
		return luasnip.jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
	end, { desc = get_desc("next"), expr = true, silent = true })
	Keymap.smap("<s-tab>", function()
		luasnip.jump(-1)
	end, { desc = get_desc("previous") })
	Keymap.smap("<tab>", function()
		luasnip.jump(1)
	end, { desc = get_desc("next") })

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
