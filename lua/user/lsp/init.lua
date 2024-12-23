---@param client_name string Server name
---@return lspconfig.Config
local function get_config(client_name)
	local configs = require("lspconfig.configs")
	return rawget(configs, client_name)
end

---@param client_name string Server name
---@return boolean
local function is_enabled(client_name)
	local c = get_config(client_name)
	return c and c.enabled ~= false
end

---@param client_name string Server name
---@param cond fun(root_dir:string, config:lspconfig.Config): boolean
local function disable(client_name, cond)
	local util = require("lspconfig.util")
	local client_config = get_config(client_name)
	---@diagnostic disable-next-line: undefined-field
	client_config.document_config.on_new_config = util.add_hook_before(
		---@diagnostic disable-next-line: undefined-field
		client_config.document_config.on_new_config,
		function(config, root_dir)
			if cond(root_dir, config) then
				config.enabled = false
			end
		end
	)
end

---@param method string see |vim.lsp.protocol.Methods|
---@return boolean # Whether the method is valid
local function validate_method(method)
	return vim.tbl_contains(vim.lsp.protocol.Methods, method)
end

---@class user.Lsp
---@field diagnostics Diagnostics
---@field keymap user.Lsp.keymap
---@field mason user.Lsp.mason
---@field overrides user.Lsp.overrides
---@field servers user.Lsp.servers
---@field words user.Lsp.words
local M = setmetatable({}, {
	__index = function(t, k)
		---@type table
		t[k] = require("user.lsp." .. k)

		return t[k]
	end,
})

---@type table<string, table<vim.lsp.Client, table<number, boolean>>>
M._supports_method = {}

---@type OnAttach<nil>
function M._check_methods(client, bufnr)
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end
	if not vim.bo[bufnr].buflisted then
		return
	end
	if vim.bo[bufnr].buftype == "nofile" then
		return
	end

	for method, clients in pairs(M._supports_method) do
		clients[client] = clients[client] or {}
		if not clients[client][bufnr] then
			if client.supports_method and client:supports_method(method, bufnr) then
				clients[client][bufnr] = true
				vim.api.nvim_exec_autocmds("User", {
					pattern = "LspSupportsMethod",
					---@class LspSupportsMethodData
					data = { client_id = client.id, bufnr = bufnr, method = method },
				})
			end
		end
	end
end
---@param bufnr integer Current buffer number
---@param method string see |vim.lsp.protocol.Methods|
---@return boolean # Whether the client(s) support the method(s)
function M.client_supports_method(bufnr, method)
	vim.validate({
		buffer = { bufnr, "number" },
		method = {
			method,
			validate_method,
			"vim.lsp.protocol.Methods",
		},
	})

	local clients = vim.lsp.get_clients({ bufnr = bufnr })
	for _, client in ipairs(clients) do
		if client:supports_method(method) then
			return true
		end
	end

	return false
end

function M.handle_typescript_clients()
	if is_enabled("denols") and is_enabled("vtsls") then
		local is_deno = require("lspconfig.util").root_pattern("deno.json", "deno.jsonc")
		disable("vtsls", is_deno)
		disable("denols", function(root_dir, config)
			if not is_deno(root_dir) then
				---@diagnostic disable-next-line: inject-field
				config.settings.deno.enable = false
				return true
			end
			return false
		end)
	end
end

function M.is_deno()
	local flietypes = { "deno.json", "deno.jsonc" }
	for _, file in pairs(flietypes) do
		if vim.fn.filereadable(file) == 1 then
			return true
		end
	end

	return false
end

---@param on_attach OnAttach<nil>
---@return integer # Autocommand id
function M.on_attach(on_attach)
	return Config.autocmd.create_autocmd({ "LspAttach" }, {
		---@param event vim.api.keyset.create_autocmd.opts.callback.event|{data:{client_id: integer}}
		---@return OnAttach|nil
		callback = function(event)
			local buffer = event.buf
			local client = vim.lsp.get_client_by_id(event.data.client_id)
			if client then
				return on_attach(client, buffer)
			end
		end,
	})
end

---@param fn OnAttach<boolean>
---@param opts? {group?: integer}
---@return integer # Autocommand id
function M.on_dynamic_capability(fn, opts)
	return Config.autocmd.create_autocmd({ "User" }, {
		pattern = "LspDynamicCapability",
		group = opts and opts.group or nil,
		---@param event vim.api.keyset.create_autocmd.opts.callback.event|{data:{buffer: integer}}
		---@return OnAttach|nil
		callback = function(event)
			local client = vim.lsp.get_client_by_id(event.data.client_id)
			local buffer = event.data.buffer
			if client then
				return fn(client, buffer)
			end
		end,
	})
end

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

	for _, client in ipairs(clients) do
		local method = vim.lsp.protocol.Methods.workspace_didRenameFiles
		if client:supports_method(method) then
			client:notify(method, changes)
		end
	end
end

---@param method string see |vim.lsp.protocol.Methods|
---@param fn OnAttach<nil>
---@return integer # Autocommand id
function M.on_supports_method(method, fn)
	vim.validate({
		method = {
			method,
			validate_method,
			"vim.lsp.protocol.Methods",
		},
	})

	M._supports_method[method] = M._supports_method[method] or setmetatable({}, { __mode = "k" })
	return Config.autocmd.create_autocmd({ "User" }, {
		---@param event vim.api.keyset.create_autocmd.opts.callback.event|{data:LspSupportsMethodData}
		---@return OnAttach<nil>
		callback = function(event)
			local client = vim.lsp.get_client_by_id(event.data.client_id)
			local buffer = event.data.bufnr
			if client and method == event.data.method then
				return fn(client, buffer)
			end
		end,
		pattern = "LspSupportsMethod",
	})
end

function M.setup()
	local register_capability = vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability]
	vim.lsp.handlers[vim.lsp.protocol.Methods.client_registerCapability] = function(err, res, ctx)
		---@diagnostic disable-next-line: no-unknown
		local client = vim.lsp.get_client_by_id(ctx.client_id)

		if client then
			for buffer in pairs(client.attached_buffers) do
				vim.api.nvim_exec_autocmds("User", {
					pattern = "LspDynamicCapability",
					data = { client_id = client.id, buffer = buffer },
				})
			end
		end

		return register_capability(err, res, ctx)
	end

	M.on_attach(M._check_methods)
	M.on_dynamic_capability(M._check_methods)
end

return M
