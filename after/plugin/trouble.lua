local utils = require("utils")

require("trouble").setup({ mode = "workspace_diagnostics", auto_close = true, use_diagnostic_signs = true })

utils.nmap("<leader>xx", vim.cmd.TroubleToggle, { desc = "Toggle trouble" })
utils.nmap("<leader>xw", vim.cmd.TroubleToggle("workspace_diagnostics"), { desc = "Toggle trouble for [w]orspace" })
utils.nmap("<leader>xd", vim.cmd.TroubleToggle("document_diagnostics"), { desc = "Toggle trouble for [d]ocument" })
utils.nmap("<leader>xl", vim.cmd.TroubleToggle("loclist"), { desc = "Toggle trouble [l]oclist" })
utils.nmap("<leader>xq", vim.cmd.TroubleToggle("quickfix"), { desc = "Toggle trouble [q]uickfix" })
utils.nmap("gR", vim.cmd.TroubleToggle("lsp_references"), { desc = "Toggle trouble for LSP [R]eference" })
