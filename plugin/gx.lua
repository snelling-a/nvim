if vim.g.gx_loaded then
	return
end
vim.g.gx_loaded = true

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
