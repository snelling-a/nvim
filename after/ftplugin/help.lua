vim.cmd.packadd("helpview.nvim")

-- Skip window rearrangement for floating windows (fzf-lua preview, etc.)
if vim.api.nvim_win_get_config(0).relative == "" then
	vim.cmd.wincmd("L")
	vim.cmd.resize({ "84", mods = { vertical = true } })
end
vim.opt_local.colorcolumn = ""
