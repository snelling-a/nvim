local snippet_path = vim.fn.stdpath("data") .. "/site/pack/core/opt/friendly-snippets"

vim.keymap.set("i", "<Tab>", function()
	if vim.snippet.active({ direction = 1 }) then
		vim.schedule(function()
			vim.snippet.jump(1)
		end)
		return
	end
	return "<Tab>"
end, { expr = true, silent = true })

-- Tab in select mode - always jump forward
vim.keymap.set("s", "<Tab>", function()
	vim.schedule(function()
		vim.snippet.jump(1)
	end)
end, { expr = true, silent = true })

-- S-Tab in insert and select modes - jump backward or fallback
vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
	if vim.snippet.active({ direction = -1 }) then
		vim.schedule(function()
			vim.snippet.jump(-1)
		end)
		return
	end
	return "<S-Tab>"
end, { expr = true, silent = true })
