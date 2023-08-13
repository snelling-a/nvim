-- taken from https://github.com/williamboman/mason.nvim/blob/main/lua/mason-core/path.lua
local function get_separator()
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

local Path = {}

--- @param path_components string[]
--- @return string
function Path.concat(path_components) return table.concat(path_components, get_separator()) end

--- Path to all LSP server configurations
--- macos: `~/.config/nvim/lua/config/lsp/server`
Path.lsp_servers = Path.concat({
	vim.fn.stdpath("config"),
	"lua",
	"config",
	"lsp",
	"server",
})

--- Path to all EFM linters/formatters
--- macos: `~/.config/nvim/lua/config/lsp/efm`
Path.linters_formatters = Path.concat({
	vim.fn.stdpath("config"),
	"lua",
	"config",
	"lsp",
	"efm",
})

--- Path to Mason.nvim packages
---@param package_name string
---@param args string|table<string>?
---@return string
function Path.get_mason_path(package_name, args)
	local list = require("config.util").table_or_string(args)

	local path_components = {
		vim.fn.stdpath("data"),
		"mason",
		"packages",
		package_name,
		unpack(list),
	}

	return Path.concat(path_components)
end

return Path
