local imap = require("utils").imap

imap("<C-g>", function() return vim.fn["codeium#Accept"]() end, { expr = true })
imap("<c-;>", function() return vim.fn["codeium#CycleCompletions"](1) end, { expr = true })
imap("<c-,>", function() return vim.fn["codeium#CycleCompletions"](-1) end, { expr = true })
imap("<c-x>", function() return vim.fn["codeium#Clear"]() end, { expr = true })
