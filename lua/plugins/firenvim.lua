local M = { "glacambre/firenvim" }

M.cond = not not vim.g.started_by_firenvim

function M.build()
	require("lazy").load({ plugins = "firenvim", wait = true })
	vim.fn["firenvim#install"](1)
end

return M
