vim.api.nvim_set_hl(0, "sshknownhostspubkey", { link = "Special", default = true })
vim.api.nvim_set_hl(0, "sshalg", { link = "Identifier", default = true })
vim.api.nvim_set_hl(0, "sshknownhostsip", { link = "Constant", default = true })

vim.cmd([[
  syntax match sshknownhostspubkey "AAAA[0-9a-zA-Z+/]\+[=]\{0,2}"
  syntax match sshalg "\<\(ssh-dss\|ssh-rsa\|ecdsa-sha2-nistp256\|ecdsa-sha2-nistp384\|ecdsa-sha2-nistp521\|ssh-ed25519\)\>"
  syntax match sshknownhostsip "\<\(\d\{1,3}\.\)\{3}\d\{1,3}\>"
]])
