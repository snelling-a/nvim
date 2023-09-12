local M = {}

-- taken from https://github.com/williamboman/mason.nvim/blob/main/lua/mason-core/path.lua
function M.get_separator()
	if jit then
		local os = string.lower(jit.os)
		if os == "linux" or os == "osx" or os == "bsd" then
			return "/"
		else
			return "\\"
		end
	else
		return string.sub(package.config, 1, 1)
	end
end

--- @param path_components string[]
--- @return string
function M.concat(path_components) return table.concat(path_components, M.get_separator()) end

--- Path to all LSP server configurations
--- macos: `~/.config/nvim/lua/config/lsp/server`
M.lsp_servers = M.concat({
	---@diagnostic disable-next-line: assign-type-mismatch
	vim.fn.stdpath("config"),
	"lua",
	"config",
	"lsp",
	"server",
})

--- Path to all EFM linters/formatters
--- macos: `~/.config/nvim/lua/config/lsp/efm`
M.linters_formatters = M.concat({
	---@diagnostic disable-next-line: assign-type-mismatch
	vim.fn.stdpath("config"),
	"lua",
	"config",
	"lsp",
	"efm",
})

return M
