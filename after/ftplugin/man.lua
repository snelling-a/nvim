local opt = vim.opt_local

local function keymap(lhs) return vim.api.nvim_buf_set_keymap(0, "n", lhs, "<C-" .. lhs .. ">", { nowait = true }) end

opt.modified = false
opt.showbreak = ""
opt.spell = false
opt.showtabline = 1

keymap("d")
keymap("u")
