local opt = vim.opt

opt.inccommand = "split"
opt.splitbelow = true
opt.splitright = true

require("config.keymap")
require("config.opt")
