if vim.g.v_highlight_loaded then
	return
end
vim.g.v_highlight_loaded = true

require("user.highlight_v").setup()
