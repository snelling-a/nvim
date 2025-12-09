vim.cmd.wincmd("L")
vim.cmd.resize({ math.floor(vim.o.columns * 0.3), mods = { vertical = true } })

local bufnr = vim.api.nvim_get_current_buf()

-- Icons
vim.api.nvim_create_autocmd({ "TextChanged" }, {
	callback = function(opts)
		require("netrw_icons").add_icons(opts.buf)
	end,
	desc = "Add icons to Netrw",
	buffer = bufnr,
})

vim.wo.list = false

-- Helper to check if cursor is on a file
local function is_file()
	local word = vim.fn["netrw#Call"]("NetrwGetWord")
	if word == "./" or word == "../" or word:match("/$") then
		return false, nil
	end
	local file = vim.fn["netrw#Call"]("NetrwFile", word)
	if vim.fn.isdirectory(file) == 1 then
		return false, nil
	end
	return true, file
end

-- Open file and close netrw
local function open_file(cmd)
	local is, file = is_file()
	if not is then
		return false
	end
	vim.cmd.wincmd("l")
	if cmd then
		vim.cmd(cmd)
	end
	vim.cmd.edit(vim.fn.fnameescape(file))
	vim.cmd("silent! wincmd h | close")
	return true
end

-- Keymaps
vim.keymap.set("n", "q", function()
	if not pcall(vim.cmd.close) then
		vim.cmd.bdelete()
	end
end, { buffer = bufnr, nowait = true, desc = "Close netrw" })

vim.keymap.set("n", "<CR>", function()
	if not open_file() then
		vim.api.nvim_feedkeys(
			vim.api.nvim_replace_termcodes("<Plug>NetrwLocalBrowseCheck", true, true, true),
			"m",
			false
		)
	end
end, { buffer = bufnr, nowait = true, desc = "Open file" })

vim.keymap.set("n", "<C-v>", function()
	open_file("vsplit")
end, { buffer = bufnr, nowait = true, desc = "Open in vsplit" })

vim.keymap.set("n", "<C-s>", function()
	open_file("split")
end, { buffer = bufnr, nowait = true, desc = "Open in split" })

vim.keymap.set("n", "<C-t>", function()
	open_file("tabnew")
end, { buffer = bufnr, nowait = true, desc = "Open in tab" })
