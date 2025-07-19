vim.api.nvim_set_hl(0, "sshknownhostspubkey", { link = "Special", default = true })
vim.api.nvim_set_hl(0, "sshalg", { link = "Identifier", default = true })
vim.api.nvim_set_hl(0, "sshknownhostsip", { link = "TSURI", default = true })

local ssh_algs = {
	"ssh-dss",
	"ssh-rsa",
	"ecdsa-sha2-nistp256",
	"ecdsa-sha2-nistp384",
	"ecdsa-sha2-nistp521",
	"ssh-ed25519",
}
local host_pattern = [[\<\(\(\d\{1,3}\.\)\{3}\d\{1,3}\)\|\([a-zA-Z0-9_-]\+\(\.[a-zA-Z0-9_-]\+\)\+\)\>]]

local sshalg_pattern = "\\<\\(" .. table.concat(ssh_algs, "\\|") .. "\\)\\>"

vim.cmd([[
  syntax match sshknownhostspubkey "AAAA[0-9a-zA-Z+/]\+[=]\{0,2}"
]])

vim.cmd('syntax match sshalg "' .. sshalg_pattern .. '"')
vim.cmd('syntax match sshknownhostsip "' .. host_pattern .. '"')
