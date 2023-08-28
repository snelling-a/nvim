local abbrev = vim.cmd.abbreviate

abbrev(":note:", [[<c-r>=printf(&commentstring, 'NOTE '.$USER.' ('.strftime("%d/%m/%y").'):')<CR>]])
abbrev(":todo:", [[<c-r>=printf(&commentstring, 'TODO('.$USER.'):')<CR>]])
abbrev("function", "function")
vim.cmd.abbrev("<expr>", "%%", "expand('%:p:h')")

vim.cmd.cabbrev("Q", "q")
vim.cmd.cabbrev("lpr", "lua print(")
