local Logger = require("config.util.logger"):new("LSP")
local Util = require("config.util")

local M = {}

--- wrapper for vim.api.nvim_buf_set_keymap
--- @param bufnr integer 'buffer number'
--- @param lhs string 'keymap'
--- @param rhs string|function 'keymap functionality'
--- @param desc string description
function M.bind(bufnr, lhs, rhs, desc)
	local opts = {
		buffer = bufnr,
		desc = desc,
	}

	return Util.nmap(lhs, rhs, opts)
end

--- wrapper for tbl_extend.completion.completionItem.snippetSupport
--- to enable (broadcasting) snippet capability for completion
--- @param opts lspconfig.Config
--- @return lspconfig.Config opts
function M.enable_broadcasting(opts)
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	---@diagnostic disable-next-line: inject-field
	capabilities.textDocument.completion.completionItem.snippetSupport = true

	opts.capabilities = Util.tbl_extend_force(opts.capabilities or {}, capabilities)

	return opts
end

--- @return lspconfig.Config opts
function M.get_opts()
	local opts = {
		flags = {
			debounce_text_changes = 150,
		},
		on_attach = require("config.lsp").on_attach,
	}

	return require("coq").lsp_ensure_capabilities(opts) --[[@as lspconfig.Config]]
end

--- wrapper for lspconfig.util.root_pattern
--- @param config_files string|string[]
--- @return function (startpath: any) -> string|unknown|nil
function M.get_root_pattern(config_files)
	local list = Util.table_or_string(config_files)

	return require("lspconfig").util.root_pattern(unpack(list))
end

--- @param cond boolean
--- @return "enabled"|"disabled" state
function M.get_state(cond) return cond and "enabled" or "disabled" end

--- @param target_dir string
--- @param cb function?
function M.ensure_installed(target_dir, cb)
	local registry = require("mason-registry")
	local dir = string.match(target_dir, "config/lsp/%a+"):gsub("/", ".")

	registry.refresh(function()
		for index, value in vim.fs.dir(target_dir) do
			if value ~= "file" then
				return
			end
			local server_name = string.gsub(index, "%.lua", "")
			local require_path = ("%s.%s"):format(dir, server_name)

			local server_config = require(require_path) or {}
			local pkg = server_config.mason_name or server_name

			if pkg == "" then
				goto continue
			else
				local package = registry.get_package(pkg)

				if not package:is_installed() then
					package:install()
				end
			end

			::continue::
			if cb then
				cb(require_path)
			end
		end
	end)
end

--- Get the full path to executable
--- @param name string
--- @return string
local function get_exec_path(name)
	if vim.fn.executable(name) == 1 then
		return vim.fn.exepath(name)
	else
		Logger:error({
			msg = "Cannot find executable: " .. name,
			title = require("config.ui.icons").cmp.nvim_lsp .. "LSP",
		})

		return ""
	end
end

--- Get the command to run a formatter
--- @param name string
--- @param args string|string[]?
--- @return string
function M.get_linter_formatter_command(name, args)
	local list = Util.table_or_string(args)

	return ("%s %s"):format(get_exec_path(name), table.concat(list, " "))
end

--- @param cond boolean
--- @param msg string
function M.toggle(cond, msg)
	cond = not cond

	if cond then
		Logger:info(("Enabled %s"):format(msg))
	else
		Logger:warn(("Disabled %s"):format(msg))
	end
end

return M
