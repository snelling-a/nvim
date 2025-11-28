---@type LazySpec
return {
	"iamcco/markdown-preview.nvim",
	cmd = { "MarkdownPreview" },
	build = function()
		require("lazy").load({ plugins = { "markdown-preview.nvim" } })
		vim.fn["mkdp#util#install"]()
	end,
	ft = { "markdown" },
	config = function()
		vim.cmd([[do FileType]])
	end,
}
