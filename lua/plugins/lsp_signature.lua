local parameter_icon = require("config.ui.icons").misc.panda

local M = { "ray-x/lsp_signature.nvim" }

M.event = "LspAttach"

M.opts = { bind = true, floating_window = false, hint_enable = true, hint_prefix = parameter_icon }

return M
