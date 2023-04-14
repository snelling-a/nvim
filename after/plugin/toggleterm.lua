local tmap = require("utils").tmap

local api = vim.api

require("toggleterm").setup({ open_mapping = "<c-\\>", shell = vim.o.shell })

local function set_terminal_keymaps()
	local opts = { buffer = 0 }
	tmap("<esc>", "<C-\\><C-n>", opts)
	tmap("jk", "<C-\\><C-n>", opts)
	tmap("<C-h>", function() vim.cmd.wincmd("h") end, opts)
	tmap("<C-j>", function() vim.cmd.wincmd("j") end, opts)
	tmap("<C-k>", function() vim.cmd.wincmd("k") end, opts)
	tmap("<C-l>", function() vim.cmd.wincmd("l") end, opts)
end

api.nvim_create_autocmd("TermOpen", {
	callback = function() set_terminal_keymaps() end,
	desc = "Set terminal keymaps",
	group = api.nvim_create_augroup("ToggleTerm", {}),
	pattern = "term://*toggleterm#*",
})
