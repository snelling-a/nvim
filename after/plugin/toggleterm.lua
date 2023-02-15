local autocmd = require("utils").autocmd

require("toggleterm").setup({ open_mapping = "<c-\\>", shell = vim.o.shell })

local function set_terminal_keymaps()
	local opts = { buffer = 0 }
	vim.keymap.set("t", "<esc>", "<C-\\><C-n>", opts)
	vim.keymap.set("t", "jk", "<C-\\><C-n>", opts)
	vim.keymap.set("t", "<C-h>", function() vim.cmd.wincmd("h") end, opts)
	vim.keymap.set("t", "<C-j>", function() vim.cmd.wincmd("j") end, opts)
	vim.keymap.set("t", "<C-k>", function() vim.cmd.wincmd("k") end, opts)
	vim.keymap.set("t", "<C-l>", function() vim.cmd.wincmd("l") end, opts)
end

autocmd("TermOpen", { pattern = "term://*toggleterm#*", callback = function() set_terminal_keymaps() end })
