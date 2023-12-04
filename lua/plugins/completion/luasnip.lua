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

function M.opts()
	vim.tbl_map(function(type)
		require(("luasnip.loaders.from_%s"):format(type)).lazy_load()
	end, {
		"vscode",
		"lua",
	})

	return {
		delete_check_events = "InsertLeave",
		history = true,
	}
end

return M
