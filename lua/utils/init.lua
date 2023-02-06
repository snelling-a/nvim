local api = vim.api

local get_map_options = function(custom_options)
	local options = { silent = true, noremap = true }
	if custom_options then
		options = vim.tbl_extend("force", options, custom_options)
	end
	return options
end

local utils = {}

utils.map = function(mode, target, source, opts) vim.keymap.set(mode, target, source, get_map_options(opts)) end

for _, mode in ipairs({ "n", "o", "i", "x", "t", "c", "v" }) do
	utils[mode .. "map"] = function(...) utils.map(mode, ...) end
end

function utils.reload_modules()
	local config_path = vim.fn.stdpath("config")
	local lua_files = vim.fn.glob(config_path .. "/**/*.lua", false, true)

	for _, file in ipairs(lua_files) do
		local module_name = string.gsub(file, ".*/(.*)/(.*).lua", "%1.%2")

		package.loaded[module_name] = nil
	end

	vim.cmd.source("$MYVIMRC")

	vim.notify("Reloaded all config modules\nReloaded lua modules", vim.log.levels.INFO, { title = "Happy hacking!" })
end

utils.opt = vim.opt

function utils.command(bufnr, name, fn, opts) api.nvim_buf_create_user_command(bufnr, name, fn, opts) end

utils.augroup = api.nvim_create_augroup
utils.autocmd = api.nvim_create_autocmd

utils.tbl_extend_force = function(...) -- move to utils, this is useful
	return vim.tbl_extend("force", ...)
end

return utils
