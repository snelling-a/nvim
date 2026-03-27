vim.pack.add({
	{ src = "https://github.com/saghen/blink.download" },
	{ src = "https://github.com/saghen/blink.pairs", version = vim.version.range("0.*") },
})

require("blink.pairs").setup({})
