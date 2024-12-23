local _set = vim.keymap.set

-- Keymaps are silent by default
---@type vim.keymap.set.function
---@diagnostic disable-next-line: duplicate-set-field
vim.keymap.set = function(mode, lhs, rhs, opts)
	opts = opts or {}
	opts.silent = opts.silent ~= false

	return _set(mode, lhs, rhs, opts)
end

local _nvim_create_autocmd = vim.api.nvim_create_autocmd
---@param event string|string[] Event(s) that will trigger the handler (`callback` or `command`).
---@param opts vim.api.keyset.create_autocmd.opts Options dict
---@return integer # Autocommand id
---@diagnostic disable-next-line: duplicate-set-field
vim.api.nvim_create_autocmd = function(event, opts)
	return _nvim_create_autocmd(event, opts)
end
