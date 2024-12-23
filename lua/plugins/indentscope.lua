---@type LazySpec
return {
	"echasnovski/mini.indentscope",
	event = { "LazyFile" },
	init = function()
		Config.autocmd.create_autocmd({ "FileType" }, {
			pattern = DisabledFiletypes,
			callback = function()
				vim.b.miniindentscope_disable = true
			end,
			group = "MiniIndentscope",
		})
	end,
	config = function()
		require("mini.indentscope").setup({
			symbol = Config.icons.ui.separator,
			options = { try_as_border = true },
		})
	end,
}
