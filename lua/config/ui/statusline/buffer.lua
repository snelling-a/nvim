local M = {}

function M.name()
	local statusline_name = vim.api.nvim_eval_statusline("%f", {}).str --[[@as string]]
	local buf_name = vim.api.nvim_buf_get_name(0)

	if vim.startswith(buf_name, "fugitive://") then
		statusline_name = vim.api.nvim_eval_statusline("%{FugitiveStatusline()}", {}).str --[[@as string]]
	end

	return statusline_name
end

return M
