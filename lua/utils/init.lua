local api = vim.api
local builtin = vim.fn
local logger = require("utils.logger")

local tbl_extend_force = function(...) return vim.tbl_extend("force", ...) end

local get_map_options = function(custom_options)
	local options = { silent = true, noremap = true }
	if custom_options then
		options = tbl_extend_force(custom_options, options)
	end
	return options
end

local utils = {}

utils.map = function(mode, target, source, opts) vim.keymap.set(mode, target, source, get_map_options(opts)) end

for _, mode in ipairs({ "n", "o", "i", "x", "t", "c", "v" }) do
	utils[mode .. "map"] = function(...) utils.map(mode, ...) end
end

function utils.reload_modules()
	local config_path = builtin.stdpath("config")
	local lua_files = builtin.glob(config_path .. "/**/*.lua", false, true)

	for _, file in ipairs(lua_files) do
		local module_name = string.gsub(file, ".*/(.*)/(.*).lua", "%1.%2")

		package.loaded[module_name] = nil
	end

	vim.cmd.source("$MYVIMRC")

	logger.info({ msg = "Reloaded all config modules\nReloaded lua modules", title = "Happy hacking!" })
end

utils.opt = vim.opt

function utils.command(bufnr, name, fn, opts) api.nvim_buf_create_user_command(bufnr, name, fn, opts) end

function utils.is_vim()
	if vim.g.started_by_firenvim or vim.g.vscode then
		return false
	else
		return true
	end
end

utils.api = api
utils.augroup = api.nvim_create_augroup
utils.autocmd = api.nvim_create_autocmd
utils.builtin = builtin
utils.tbl_extend_force = tbl_extend_force
return utils
