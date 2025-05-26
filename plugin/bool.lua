if vim.g.bool_loaded then
	return
end
vim.g.bool_loaded = true

local function flip_bool()
	local bools = {
		["true"] = "false",
		["false"] = "true",
		True = "False",
		False = "True",
		["0"] = "1",
		["1"] = "0",
		on = "off",
		off = "on",
		let = "const",
		const = "let",
		["private"] = "public",
		["public"] = "private",
	}

	local cursor = vim.api.nvim_win_get_cursor(0)
	local line = cursor[1] - 1
	vim.cmd('exe "norm! wb"')
	local begin_word = vim.api.nvim_win_get_cursor(0)[2]
	vim.cmd('exe "norm! e"')
	local end_word = vim.api.nvim_win_get_cursor(0)[2] + 1

	local word = vim.api.nvim_buf_get_text(0, line, begin_word, line, end_word, {})[1]

	if bools[word] ~= nil then
		vim.api.nvim_buf_set_text(0, line, begin_word, line, end_word, { bools[word] })
	end

	vim.api.nvim_win_set_cursor(0, cursor)
end

vim.keymap.set({ "n" }, "!", flip_bool, { desc = "Flip boolean value" })
