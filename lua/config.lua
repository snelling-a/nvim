local Lsp = require("lsp")
local Util = require("util")

local M = {}

---@param name "abbrev" | "autocmd" | "command" | "opt" | "keymap" | "ui" | "util.session"
local function load(name)
	local function _load(mod)
		Util.try(function()
			require(mod)
		end, { msg = ("Failed loading %s"):format(mod) })
	end

	_load(name)

	local pattern = ("Set%s%s"):format(name:sub(1, 1):upper(), name:sub(2))
	vim.api.nvim_exec_autocmds("User", { pattern = pattern, modeline = false })
end

function M.setup()
	load("opt")
	load("ui")

	require("_lazy")

	--- `false` if opening vim with a file(s)
	local delay_load = vim.fn.argc(-1) == 0
	if not delay_load then
		load("abbrev")
		load("autocmd")
		load("command")
	end

	vim.api.nvim_create_autocmd("User", {
		group = require("autocmd").augroup("VimLoaded"),
		pattern = "VeryLazy",
		callback = function()
			if delay_load then
				load("abbrev")
				load("autocmd")
				load("command")
			end
			load("keymap")
			load("util.session")

			Lsp.format.setup()
		end,
	})

	Util.try(function()
		vim.cmd.colorscheme("base16-default-dark")
	end, {
		msg = "Could not load your colorscheme",
		on_error = function(msg)
			Util.logger:error(msg)
			vim.cmd.colorscheme("default")
		end,
	})
end

local DID_INIT = false
function M.init()
	if DID_INIT then
		return
	end
	DID_INIT = true

	package.preload["plugins.lsp.format"] = function()
		return Lsp.format
	end

	Util.logger.delay_notify()

end

return M
