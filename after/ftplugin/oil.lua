local function oil_statusline()
	local path = vim.api.nvim_buf_get_name(0):gsub("^oil://", "")
	local cwd = vim.fn.getcwd()
	if path:sub(1, #cwd) == cwd then
		path = vim.fn.fnamemodify(cwd, ":t") .. path:sub(#cwd + 1)
	end
	return "󰏇  " .. path
end

_G._oil_statusline = oil_statusline
vim.opt_local.statusline = "%{%v:lua._oil_statusline()%}"
