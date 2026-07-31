vim.pack.add({
	{ src = "https://github.com/saghen/blink.download" },
	{ src = "https://github.com/saghen/blink.pairs", version = vim.version.range("0.*") },
})

vim.api.nvim_create_autocmd({ "PackChanged" }, {
	callback = function(args)
		if
			args.data
			and args.data.spec.name == "blink.pairs"
			and (args.data.kind == "install" or args.data.kind == "update")
		then
			vim.notify(args.data.spec.name .. " updated, downloading prebuilt binaries")
			require("blink.pairs").download():pwait(60000)
		end
	end,
	desc = "Handle blink.pairs updates",
	group = vim.api.nvim_create_augroup("blink.pairs.update-handler", { clear = true }),
})

require("blink.pairs").setup({})
