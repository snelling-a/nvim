if vim.g.gx_loaded then
	return
end
vim.g.gx_loaded = true

local opener = (function()
	if vim.fn.has("mac") == 1 then
		return { "open" }
	elseif vim.fn.has("win32") == 1 then
		if vim.fn.executable("rundll32") == 1 then
			return { "rundll32", "url.dll,FileProtocolHandler" }
		end
	elseif vim.fn.executable("wslview") == 1 then
		return { "wslview" }
	elseif vim.fn.executable("explorer.exe") == 1 then
		return { "explorer.exe" }
	elseif vim.fn.executable("xdg-open") == 1 then
		return { "xdg-open" }
	end
end)()

-- use |gx| / |vim.ui.open()| to open URLs
---@param path string Path or URL to open
---@return vim.SystemObj|nil # call to `vim.system`
---@return string|nil # Error message
---@diagnostic disable-next-line: duplicate-set-field
vim.ui.open = function(path)
	if type(path) ~= "string" then
		return nil, ("%q is not a string"):format(tostring(path))
	end

	if not opener then
		return nil, "vim.ui.open: no handler found"
	end

	local is_uri = path:match("%w+:")
	local is_half_url = path:match("%.com$") or path:match("%.com%.")
	local is_repo = vim.bo.filetype == "lua"
		and path:match("^[%w_%-%.]+/[%w_%-%.]+$")
	local is_dir = path:match("^/")
	local is_npm_package = vim.bo.filetype == "json"
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

	local cmd = vim.list_extend({}, opener)
	table.insert(cmd, path)

	return vim.system(cmd, { text = true, detach = true }), nil
end
