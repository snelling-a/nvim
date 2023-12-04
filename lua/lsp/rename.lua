local Methods = vim.lsp.protocol.Methods
local workspace_willRenameFiles = Methods.workspace_willRenameFiles
local workspace_didRenameFiles = Methods.workspace_didRenameFiles

---@param client lsp.Client
---@param bufnr integer
---@param data {old_name:string,new_name:string}
local function prepare_rename(client, bufnr, data)
	local params = {
		files = {
			{ newUri = vim.uri_from_fname(data.new_name), oldUri = vim.uri_from_fname(data.old_name) },
		},
	}

	---@diagnostic disable-next-line: invisible
	local resp = client.request_sync(workspace_willRenameFiles, params, 1000, bufnr)

	if resp and resp.result ~= nil then
		vim.lsp.util.apply_workspace_edit(resp.result, client.offset_encoding)
	end

	local didRename = vim.tbl_get(client, "server_capabilities", "workspace", "fileOperations", "didRename")

	if didRename ~= nil then
		client.notify(workspace_didRenameFiles, params)
	end
end

---@param client lsp.Client
---@param bufnr integer
local function rename_file(client, bufnr)
	local old_name = vim.api.nvim_buf_get_name(0)

	vim.ui.input({
		prompt = "New name: ",
		default = vim.fn.fnamemodify(old_name, ":t"),
	}, function(name)
		if not name then
			return
		end

		local new_name = ("%s/%s"):format(vim.fs.dirname(old_name), name)
		prepare_rename(client, bufnr, {
			old_name = old_name,
			new_name = new_name,
		})

		vim.lsp.util.rename(old_name, new_name, {})
	end)
end

local allowed_servers = {
	lua_ls = true,
	tsserver = true,
	["typescript-tools"] = true,
}

---@class lsp.rename
local M = {}

---@param client lsp.Client
---@param bufnr integer
function M.on_attach(client, bufnr)
	local ok_will, is_will_rename_supported = pcall(function()
		return client.supports_method(workspace_willRenameFiles)
	end)
	local ok_did, is_did_rename_supported = pcall(function()
		return client.supports_method(workspace_didRenameFiles)
	end)

	if
		not ok_will
		or not ok_did
		or not is_will_rename_supported
		or not is_did_rename_supported
		or not allowed_servers[client.name]
	then
		return
	end

	local name = client.name:gsub("[-_](%w)", string.upper)
	name = require("util").capitalize_first_letter(name)
	vim.api.nvim_create_user_command(("RenameFileWith%s"):format(name), function()
		rename_file(client, bufnr)
	end, {})
end

return M
