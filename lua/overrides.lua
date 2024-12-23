local _set = vim.keymap.set

-- Keymaps are silent by default
---@type vim.keymap.set.function
---@diagnostic disable-next-line: duplicate-set-field
vim.keymap.set = function(mode, lhs, rhs, opts)
	opts = opts or {}
	opts.silent = opts.silent ~= false

	return _set(mode, lhs, rhs, opts)
end

-- use |gx| / |vim.ui.open()| to open URLs
---@param path string Path or URL to open
---@return nil|vim.SystemObj # call to `vim.system`
---@return string|nil # Error message
---@diagnostic disable-next-line: duplicate-set-field
vim.ui.open = function(path)
	local okay = pcall(vim.validate, { path = { path, "string" } })

	if not okay then
		return nil, ("%q is not a string"):format(tostring(path))
	end

	local is_uri = path:match("%w+:")
	local is_half_url = path:match("%.com$") or path:match("%.com%.")
	local is_repo = vim.bo.filetype == "lua" and path:match("%w/%w") and vim.fn.count(path, "/") == 1
	local is_dir = path:match("/%w")
	local is_npm_package = vim.bo.filetype == "json"
		--		and current_file:match("package%-lock?%.json")
		and vim.fn.expand("%:t") == "package.json"
		and path:match("@?[%w-%d]+/?[%w-%d]+")

	if not is_uri then
		if is_half_url then
			path = "https://" .. path
		elseif is_repo then
			path = "https://github.com/" .. path
		elseif is_npm_package then
			path = "https://www.npmjs.com/package/" .. path
		elseif not is_dir then
			path = "https://ecosia.com/search?q=" .. path
		else
			path = vim.fs.normalize(path)
		end
	end

	local cmd ---@type string[]

	if vim.fn.has("mac") == 1 then
		cmd = { "open", path }
	elseif vim.fn.has("win32") == 1 then
		if vim.fn.executable("rundll32") == 1 then
			cmd = { "rundll32", "url.dll,FileProtocolHandler", path }
		else
			return nil, "vim.ui.open: rundll32 not found"
		end
	elseif vim.fn.executable("wslview") == 1 then
		cmd = { "wslview", path }
	elseif vim.fn.executable("explorer.exe") == 1 then
		cmd = { "explorer.exe", path }
	elseif vim.fn.executable("xdg-open") == 1 then
		cmd = { "xdg-open", path }
	else
		return nil, "vim.ui.open: no handler found (tried: wslview, explorer.exe, xdg-open)"
	end

	return vim.system(cmd, { text = true, detach = true }), nil
end

local _nvim_create_autocmd = vim.api.nvim_create_autocmd
---@param event string|string[] Event(s) that will trigger the handler (`callback` or `command`).
---@param opts vim.api.keyset.create_autocmd.opts Options dict
---@return integer # Autocommand id
---@diagnostic disable-next-line: duplicate-set-field
vim.api.nvim_create_autocmd = function(event, opts)
	return _nvim_create_autocmd(event, opts)
end

local Log = require("log")

local _notify = vim.notify
---@param msg string Content of the notification to show to the user.
---@param level? integer One of the values from |vim.log.levels|.
---@param opts {once:boolean}? If `once` is true, only show the notification once.
---@return nil
local function notify(msg, level, opts)
	opts = opts or {}
	level = level or vim.log.levels.INFO
	if vim.in_fast_event() then
		return vim.schedule(function()
			notify(msg, level, { once = opts.once })
		end)
	end

	Log(vim.inspect({ level, msg }))
	local notifier = opts.once and vim.notify_once or _notify
	notifier(msg, level)
end
vim.notify = notify

local _print = print
---@param ... any
-- luacheck: globals print
print = function(...)
	local args = { ... }
	local new_args = {}
	for _, arg in ipairs(args) do
		table.insert(new_args, vim.inspect(arg))
	end
	_print(unpack(new_args))
	Log(new_args)
end

vim.filetype.add({
	pattern = {
		["%.?ignore.*"] = "gitignore",
		["%.env%.[%w_.-]+"] = "sh",
		[".*%.log"] = "log",
		["*.pcss"] = "css",
		[".*/%.?git/attributes"] = "gitattributes",
		[".*/%.?git/ignore"] = "gitignore",
		[".*/kitty/.+%.conf"] = "bash",
		[".*/tmux/.+%.conf"] = "tmux",
		["known_hosts"] = "sshknownhosts",
		[".*%.?conf(ig)"] = function(path)
			if path:match("git") then
				return "gitconfig"
			end

			return "conf"
		end,
		[".*"] = {
			function(path, buf)
				return vim.bo[buf]
						and vim.bo[buf].filetype ~= "bigfile"
						and path
						and vim.fn.getfsize(path) > 1024 * 1024 * 1.5 -- 1.5 MB
						and "bigfile"
					or nil
			end,
		},
	},
})

Config.lsp.overrides.on_attach()
