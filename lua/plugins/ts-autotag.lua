---@type LazySpec
return {
	"windwp/nvim-ts-autotag",
	event = { "InsertEnter" },
	ft = { "html", "javascript", "jsx", "markdown", "tsx", "typescript" },
	config = function()
		require("nvim-ts-autotag").setup()
	end,
}
