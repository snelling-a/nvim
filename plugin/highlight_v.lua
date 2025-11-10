if vim.g.v_highlight_loaded then
	return
end
vim.g.v_highlight_loaded = true

local VHighlight = require("user.highlight_v")
local group = require("user.autocmd").augroup("highlight.v")

vim.api.nvim_create_autocmd({ "CmdlineEnter" }, {
	callback = VHighlight.highlight,
	desc = "Highlight region on CmdlineEnter",
	group = group,
})
vim.api.nvim_create_autocmd({ "CmdlineLeave" }, {
	callback = VHighlight.clear,
	desc = "Clear highlight on CmdlineLeave",
	group = group,
})
vim.api.nvim_create_autocmd({ "ModeChanged" }, {
	callback = VHighlight.update_region,
	desc = "Update selection region on mode change",
	group = group,
	pattern = "*:[vV\x16]*",
})
vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
	callback = VHighlight.update_region,
	desc = "Update selection region on cursor move",
	group = group,
})
