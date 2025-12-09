-- Keymaps for native vim.snippet and inline completion
vim.keymap.set("i", "<Tab>", function()
	if vim.snippet.active({ direction = 1 }) then
		vim.schedule(function()
			vim.snippet.jump(1)
		end)
		return ""
	end
	if vim.lsp.inline_completion and vim.lsp.inline_completion.get() then
		return ""
	end
	return "<Tab>"
end, { expr = true, silent = true })

vim.keymap.set("s", "<Tab>", function()
	vim.schedule(function()
		vim.snippet.jump(1)
	end)
	return ""
end, { expr = true, silent = true })

vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
	if vim.snippet.active({ direction = -1 }) then
		vim.schedule(function()
			vim.snippet.jump(-1)
		end)
		return ""
	end
	return "<S-Tab>"
end, { expr = true, silent = true })
