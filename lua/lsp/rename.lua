---@type LSP
local Lsp = require("lsp")
local Logger = Lsp.logger

local Methods = vim.lsp.protocol.Methods
local workspace_willRenameFiles = Methods.workspace_willRenameFiles
local workspace_didRenameFiles = Methods.workspace_didRenameFiles

local allowed_servers = {
	lua_ls = true,
	tsserver = true,
	["typescript-tools"] = true,
}

---@param client lsp.Client
local function is_ok(client)
	local ok_will, is_will_rename_supported = pcall(function()
		return client.supports_method(workspace_willRenameFiles)
	end)
	local ok_did, is_did_rename_supported = pcall(function()
		return client.supports_method(workspace_didRenameFiles)
	end)

	return ok_will or ok_did or is_will_rename_supported or is_did_rename_supported or allowed_servers[client.name]
end

---@class lsp.rename
local M = {}

function M.rename(from, to)
	local clients = Lsp.util.get_clients()
	for _, client in pairs(clients) do
		if is_ok(client) then
			local params = {
				files = {
					{
						newUri = vim.uri_from_fname(to),
						oldUri = vim.uri_from_fname(from),
					},
				},
			}

			---@diagnostic disable-next-line: invisible
			local resp = client.request_sync(workspace_willRenameFiles, params, 1000, 0) or {}

			if resp and resp.result ~= nil then
				vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
				Logger:info("Rename succeeded")
			end

			local didRename = vim.tbl_get(client, "server_capabilities", "workspace", "fileOperations", "didRename")

			if didRename ~= nil then
				client.notify(workspace_didRenameFiles, params)
			end
		end
	end
end

return setmetatable(M, {
	__call = function(_, ...)
		return M.rename(...)
	end,
})
