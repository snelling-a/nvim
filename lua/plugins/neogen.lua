---@type LazySpec
return {
	"danymat/neogen",
	cmd = { "Neogen" },
	config = function()
		require("neogen").setup({ snippet_engine = "nvim" })
	end,
}
