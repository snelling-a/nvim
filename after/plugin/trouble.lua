local utils = require("utils")

require("trouble").setup({ mode = "workspace_diagnostics", auto_close = true, use_diagnostic_signs = true })

utils.nmap("<leader>xx", "<cmd>TroubleToggle<cr>")
utils.nmap("<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>")
utils.nmap("<leader>xd", "<cmd>TroubleToggle document_diagnostics<cr>")
utils.nmap("<leader>xl", "<cmd>TroubleToggle loclist<cr>")
utils.nmap("<leader>xq", "<cmd>TroubleToggle quickfix<cr>")
utils.nmap("gR", "<cmd>TroubleToggle lsp_references<cr>")
