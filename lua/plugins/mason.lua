vim.pack.add({ { src = "https://github.com/williamboman/mason.nvim", name = "mason" } })
require("mason").setup()

local function get_lsp_servers()
	local servers = {}
	for _, path in ipairs(vim.api.nvim_get_runtime_file("lsp/*.lua", true)) do
		local name = vim.fs.basename(path):match("^(.*)%.lua$")
		if name then
			table.insert(servers, name)
		end
	end
	return servers
end

local function get_formatters()
	local formatters = {}
	local ok, conform = pcall(require, "conform")
	if not ok then
		return formatters
	end
	local formatters_by_ft = conform.formatters_by_ft or {}
	for _, ft_formatters in pairs(formatters_by_ft) do
		for _, name in ipairs(ft_formatters) do
			if type(name) == "string" then
				formatters[name] = true
			end
		end
	end
	return vim.tbl_keys(formatters)
end

local function get_linters()
	local linters = {}
	local ok, lint = pcall(require, "lint")
	if not ok then
		return linters
	end
	local linters_by_ft = lint.linters_by_ft or {}
	for _, ft_linters in pairs(linters_by_ft) do
		for _, name in ipairs(ft_linters) do
			if type(name) == "string" then
				linters[name] = true
			end
		end
	end
	return vim.tbl_keys(linters)
end

local function ensure_tools()
	local registry = require("mason-registry")

	local tools = {}
	for _, server in ipairs(get_lsp_servers()) do
		tools[server] = true
	end
	for _, formatter in ipairs(get_formatters()) do
		tools[formatter] = true
	end
	for _, linter in ipairs(get_linters()) do
		tools[linter] = true
	end

	registry.refresh(function()
		for name in pairs(tools) do
			local ok, pkg = pcall(registry.get_package, name)
			if ok and not pkg:is_installed() then
				vim.notify("Mason: installing " .. name, vim.log.levels.INFO)
				pkg:install()
			end
		end
	end)
end

vim.api.nvim_create_user_command("MasonEnsureInstalled", ensure_tools, {
	desc = "Ensure mason tools are installed",
})

vim.defer_fn(ensure_tools, 500)
