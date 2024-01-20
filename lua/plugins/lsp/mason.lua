local Icons = require("ui.icons").progress

---@type LazySpec
local M = { "williamboman/mason.nvim" }

M.cmd = "Mason"

M.dependencies = { "williamboman/mason-lspconfig.nvim" }

M.event = require("util").constants.lazy_event

M.build = { ":MasonUpdate" }

---@type MasonSettings
M.opts = {
	ui = {
		border = "rounded",
		icons = {
			package_installed = Icons.done,
			package_pending = Icons.pending,
			package_uninstalled = Icons.trash,
		},
	},
}

---@param opts MasonOpts
function M.config(_, opts)
	require("mason").setup(opts)

	require("lsp")--[[@as LSP]]
		.mason
		.ensure_installed(opts.ensure_installed)

	require("mason-registry"):on("package:install:success", function()
		vim.defer_fn(function()
			-- trigger FileType event to possibly load this newly installed LSP server
			require("lazy.core.handler.event").trigger({
				event = "FileType",
				buf = vim.api.nvim_get_current_buf(),
			})
		end, 100)
	end)
end

return M
