---@class user.Lsp
local M = setmetatable({}, {
	__index = function(t, k)
		---@type table
		t[k] = require("user.lsp." .. k)

		return t[k]
	end,
})


---@param from string
---@param to string
function M.on_rename_file(from, to)
	local changes = {
		files = {
			{ oldUri = vim.uri_from_fname(from), newUri = vim.uri_from_fname(to) },
		},
	}

	local clients = vim.lsp.get_clients()
	for _, client in ipairs(clients) do
		local method = vim.lsp.protocol.Methods.workspace_willRenameFiles
		if client:supports_method(method) then
			local resp = client:request_sync(method, changes, 1000, 0)
			if resp and resp.result ~= nil then
				vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
			end
		end
	end

return M
