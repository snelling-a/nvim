local opt_local = vim.opt_local

local function keymap(lhs) return vim.api.nvim_buf_set_keymap(0, "n", lhs, "<C-" .. lhs .. ">", { nowait = true }) end

opt_local.modified = false
opt_local.showbreak = ""
opt_local.spell = false
opt_local.showtabline = 1

keymap("d")
keymap("u")
