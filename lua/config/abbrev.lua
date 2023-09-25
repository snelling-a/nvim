local iabbrev = vim.cmd.iabbrev

iabbrev(":note:", [[<c-r>=printf(&commentstring, 'NOTE '.$USER.' ('.strftime("%d/%m/%y").'):')<CR>]])
iabbrev(":todo:", [[<c-r>=printf(&commentstring, 'TODO('.$USER.'):')<CR>]])
iabbrev("clo", "console.log()<left>")
vim.cmd.abbrev("<expr>", "%%", "expand('%:p:h')")

vim.cmd.cabbrev("Q", "q")
vim.cmd.cabbrev("lpr", "lua print()<left>")
vim.cmd.cabbrev("lpi", "lua print(vim.inspect())<left><left>")
