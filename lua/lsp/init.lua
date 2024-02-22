local tbl_extend_force = require("util").tbl_extend_force

---@class LSP
local M = {}

M.logger = require("util.logger"):new("LSP")

---@param opts lsp.opts
---@return LSP
function M:init(opts)
	vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

	self = setmetatable({
		opts = opts,
		servers = opts.servers,
	}, { __index = self })

	return self
end

function M.get_capabilities()
	local ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

	return tbl_extend_force(
		vim.lsp.protocol.make_client_capabilities(),
		ok and cmp_nvim_lsp.default_capabilities() or {},
		{
			workspace = {
				didChangeWatchedFiles = {
					dynamicRegistration = false,
				},
			},
		}
	)
end

function M:get_servers()
	return self.servers
end

---@param server string server name
function M:setup(server)
	local server_opts = tbl_extend_force({
		capabilities = vim.deepcopy(M:get_capabilities() or {}),
	}, self.servers[server] or {})

	if self.opts.setup[server] then
		if self.opts.setup[server](server, server_opts) then
			return
		end
	elseif self.opts.setup["*"] then
		if self.opts.setup["*"](server, server_opts) then
			return
		end
	end

	require("lspconfig")[server].setup(server_opts)
end

---@param on_attach fun(client:lsp.Client, bufnr:integer)
function M.on_attach(on_attach)
	vim.api.nvim_create_autocmd({ "LspAttach" }, {
		---@param ev Ev
		callback = function(ev)
			local bufnr = ev.buf
			local client = vim.lsp.get_client_by_id(ev.data.client_id) or {}
			on_attach(client, bufnr)
		end,
	})
end

return setmetatable(M, {
	__index = function(self, field)
		self[field] = require(("lsp.%s"):format(field))
		return self[field]
	end,
})
